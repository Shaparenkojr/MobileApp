

import Foundation
import Combine

final class MakeOrderViewModel: ObservableObject {
    private let adapter: ViewModelAdapterProtocol = ViewModelAdapter()
    
    @Published private(set) var finalSumWithSales: Double = 0
    @Published private(set) var totalDiscountPromocodes: Double = 0
    
    @Published var orderData: [Order.Product] = []
    @Published var paymentData: [Order.PaymentType] = []
    @Published var promocodeData: [Order.Promocode] = []
    
    @Published private(set) var fixedDiscounts: [String: Double] = [:]
    @Published private(set) var totalPriceForProducts: Double = 0
    
    @Published var errorMessage: String = ""
    @Published var isPresentedModal: Bool = false
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        bindings()
    }
    
    deinit {
        print("deinited")
    }
}

extension MakeOrderViewModel {
    
    func activatePromocode(isOn: Bool, at index: Int) {
        adapter.updatePromocodeState(isOn: isOn, at: index)
    }

}

private extension MakeOrderViewModel {
    
    func bindings() {
        adapter.fetchProductData()
            .sink { [weak self] order in
                if let order = order {
                    self?.orderData = order.products
                    self?.paymentData = order.payment
                    self?.promocodeData = order.promocodes
                }
            }
            .store(in: &subscriptions)
        
        adapter.fetchErrorMessage()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                self.errorMessage = errorMessage
            }
            .store(in: &subscriptions)
        
        adapter.recalculateTotalPrice()
            .sink { [weak self] newPrice in
                self?.finalSumWithSales = newPrice
            }
            .store(in: &subscriptions)
        
        Publishers.CombineLatest4(
            adapter.fetchTotalSumForProducts(),
            adapter.fetchTotalDiscountPromocodes(),
            adapter.fetchFixedDiscount(),
            adapter.fetchPaymentDiscount()
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] totalSumMain, totalDiscountPromocodes, fixedDiscount, paymentDiscount in
            guard let self = self else { return }
            
            self.totalPriceForProducts = totalSumMain
            self.totalDiscountPromocodes = totalDiscountPromocodes
            self.fixedDiscounts["fixedDiscount"] = fixedDiscount
            self.fixedDiscounts["paymentDiscount"] = paymentDiscount
            
            self.finalSumWithSales = totalSumMain
            - totalDiscountPromocodes
            - fixedDiscount
            - paymentDiscount
        }
        .store(in: &subscriptions)

    }
}

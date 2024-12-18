

import Combine

protocol ViewModelAdapterProtocol {
    func fetchProductData() -> AnyPublisher<Order?, Never>
    func recalculateTotalPrice() -> AnyPublisher<Double, Never>
    func fetchTotalSumForProducts() -> AnyPublisher<Double, Never>
    func fetchFixedDiscount() -> AnyPublisher<Double, Never>
    func fetchPaymentDiscount() -> AnyPublisher<Double, Never>
    func fetchTotalDiscountPromocodes() -> AnyPublisher<Double, Never>
    func fetchErrorMessage() -> AnyPublisher<String, Never>
    func fetchCountOfActivatePromocodes() -> AnyPublisher<Int, Never>
    func updatePromocodeState(isOn: Bool, at index: Int)
}

final class ViewModelAdapter {
    
    private let oldOrderViewModel = OrderViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        oldOrderViewModel.setData()
    }
}

extension ViewModelAdapter: ViewModelAdapterProtocol {
    
    func updatePromocodeState(isOn: Bool, at index: Int) {
        oldOrderViewModel.handleSwitch(isOn, indexPath: index)
    }
    
    func fetchProductData() -> AnyPublisher<Order?, Never> {
        oldOrderViewModel.$data
            .eraseToAnyPublisher()
    }

    func recalculateTotalPrice() -> AnyPublisher<Double, Never> {
        oldOrderViewModel.$errorMessage
            .combineLatest(oldOrderViewModel.$totalSum)
            .filter { errorMessage, _ in errorMessage.isEmpty }
            .map { _, totalSum in totalSum }
            .eraseToAnyPublisher()
    }
    
    func fetchTotalSumForProducts() -> AnyPublisher<Double, Never> {
        oldOrderViewModel.$totalSumMain
            .eraseToAnyPublisher()
    }
    
    func fetchFixedDiscount() -> AnyPublisher<Double, Never> {
        oldOrderViewModel.$fixedDiscount
            .eraseToAnyPublisher()
    }
    
    func fetchPaymentDiscount() -> AnyPublisher<Double, Never> {
        oldOrderViewModel.$paymentDiscount
            .eraseToAnyPublisher()
    }
    
    func fetchTotalDiscountPromocodes() -> AnyPublisher<Double, Never> {
        oldOrderViewModel.$totalDiscount
            .eraseToAnyPublisher()
    }
    
    func fetchErrorMessage() -> AnyPublisher<String, Never> {
        oldOrderViewModel.$errorMessage
            .eraseToAnyPublisher()
    }
    
    func fetchCountOfActivatePromocodes() -> AnyPublisher<Int, Never> {
        oldOrderViewModel.$countOfChoosenPromocodes
            .eraseToAnyPublisher()
    }
}


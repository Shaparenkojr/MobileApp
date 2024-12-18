//
//  NewPromocodeViewModel.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 27.10.2024.
//

import Foundation

protocol NewPromocodeViewModelDelegate: AnyObject {
    func showError(errorMessage: String)
    func popToPreviouesController(_ newData: Order)
}

final class NewPromocodeViewModel {
    
    private var data: Order?
    
    private var errorMessage: String = "" {
        didSet {
            delegate?.showError(errorMessage: errorMessage)
        }
    }
    
    weak var delegate: NewPromocodeViewModelDelegate?
    
    init(data: Order?) {
        self.data = data
    }
    
    func addNewPromocode(_ promocodeName: String) {
        guard var data = data,
              let availableForActiveOrder = data.availableForActive else {
            return
        }

        var indexAvailableForActiveOrder = 0
        var countOfActivePromocodes: Int = 0
        var isPromocodeExist: Bool = false
        for (index, availablePromocode) in availableForActiveOrder.enumerated() {
            if data.promocodes[index].title == promocodeName {
                errorMessage = "Этот промокод уже активирован"
                return
            }
            if availablePromocode.title == promocodeName {
                indexAvailableForActiveOrder = index
                isPromocodeExist = true
                break
            }
        }
        
        if isPromocodeExist {
            for(index, activePromocode) in data.promocodes.enumerated() {
                if activePromocode.active {
                    countOfActivePromocodes += 1
                    if countOfActivePromocodes == 2 {
                        print(index)
                        data.promocodes.replaceSubrange(index...index, with: [availableForActiveOrder[indexAvailableForActiveOrder]])
                        data.promocodes[index].active = true
                        break
                    }
                }
            }
            if countOfActivePromocodes == 1 {
                data.promocodes.insert(availableForActiveOrder[indexAvailableForActiveOrder], at: 0)
                data.promocodes[0].active = true
            }
            delegate?.popToPreviouesController(data)
        } else {
            errorMessage = "К сожалению, данного промокода не существует"
        }
    }
}

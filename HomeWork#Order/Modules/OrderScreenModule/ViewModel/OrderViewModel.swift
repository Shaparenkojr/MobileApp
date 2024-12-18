

import Foundation
import Combine

protocol OrderViewModelDelegate: AnyObject {
    func setData(_ data: Order)
    func showAlert(_ alertTitle: String, _ alertMessage: String)
    func countOfChoosenPromocodesDidChanged(_ count: Int)
    func isActiveCellDidChanged(_ index: Int)
    func didUpdateTotalSum(_ totalSum: Double, totalDiscount: Double)
    func didHidePromocode(_ data: Order, isActive: Bool)
    func showController(_ data: Order)
    func showSnackView()
}

class OrderViewModel {
    
    @Published private(set) var data: Order? {
        didSet {
            if let data = data {
                delegate?.setData(data)
            }
        }
    }
    
    @Published private(set) var errorMessage: String = "" {
        didSet {
            if errorMessage != "" {
                delegate?.showAlert(ErrorMessages.titleAlert, errorMessage)
            }
        }
    }
    
    @Published private(set) var countOfChoosenPromocodes: Int = 0 {
        didSet {
            delegate?.countOfChoosenPromocodesDidChanged(countOfChoosenPromocodes)
        }
    }
    
    private var isActiveCell: Int? {
        didSet {
            if let isActiveCell {
                delegate?.isActiveCellDidChanged(isActiveCell)
            }
        }
    }
    
    @Published private(set) var totalSum: Double = 0.0 {
        didSet {
            notifyUpdate()
        }
    }
    
    @Published private(set) var totalSumMain: Double = 0.0
    private var activePromocodes: [Order.Promocode] = []
    private var updatedPromocodes: [Order.Promocode] = []
    private var displayedPromocodes: [Order.Promocode] = []
    @Published private(set) var fixedDiscount: Double = 0.0
    @Published private(set) var paymentDiscount: Double = 0.0
    @Published private(set) var totalDiscount: Double = 0.0
    private var isPromocodesHidden: Bool = false
    private var isForcingToggle = false
    
    weak var delegate: OrderViewModelDelegate?
    
    func udpateOrderData(_ data: Order) {
        self.data = data
        updatedPromocodes = data.promocodes
        countOfChoosenPromocodes = 0
        isDataCorrect()
        setupDataForBottomView()
        delegate?.showSnackView()
    }
    
    func setData() {
        let order = (Order(screenTitle: "Промокоды",
                           promocodes: [Order.Promocode.init(title: "HELLO",
                                                             percent: 5,
                                                             endDate: Date(),
                                                             info: "Промокод действует на первый заказ в приложении",
                                                             active: true),
                                        Order.Promocode.init(title: "VESNA23",
                                                             percent: 5,
                                                             endDate: Date(),
                                                             info: "Промокод действует для заказов от 30 000 ₽",
                                                             active: false),
                                        Order.Promocode.init(title: "4300162112532",
                                                             percent: 5,
                                                             endDate: Date(),
                                                             info: nil,
                                                             active: false),
                                        Order.Promocode.init(title: "4300162112534",
                                                             percent: 5,
                                                             endDate: Date(),
                                                             info: nil,
                                                             active: false),
                                        Order.Promocode.init(title: "4300162112531",
                                                             percent: 15,
                                                             endDate: Date(),
                                                             info: nil,
                                                             active: true)],
                           payment: [Order.PaymentType(paymentImage: "sberbank",
                                                       title: "SberPay",
                                                       description: "Через приложение сбербанк",
                                                       sale: 5,
                                                       additionalBenefits: Order.AdditionalBenefits(image: "sberBonus",
                                                                                                    bonusPercent: 5)),
                                     Order.PaymentType(paymentImage: "bankCard",
                                                       title: "Банковской картой",
                                                       description: "Visa, MasterCard, МИР",
                                                       sale: 5,
                                                       additionalBenefits: nil),
                                     Order.PaymentType(paymentImage: "yandexPay",
                                                       title: "Яндекс Пэй со сплитом",
                                                       description: "Оплата частями",
                                                       sale: 5,
                                                       additionalBenefits: nil),
                                     Order.PaymentType(paymentImage: "tinkoff",
                                                       title: "Рассрочка Тинькофф",
                                                       description: "На 3 месяца без переплат",
                                                       sale: 5,
                                                       additionalBenefits: nil),
                                     Order.PaymentType(paymentImage: "tinkoffPay",
                                                       title: "Tinkoff Pay",
                                                       description: "Через приложение Тинькофф",
                                                       sale: 5,
                                                       additionalBenefits: nil),
                                     Order.PaymentType(paymentImage: "wallet",
                                                       title: "Оплатить при получении",
                                                       description: "Наличными или картами",
                                                       sale: nil,
                                                       additionalBenefits: nil)],
                           products: [Order.Product(productImage: URL(string: "https://t3.ftcdn.net/jpg/05/64/35/80/360_F_564358021_KBRaemBSj9FGjZlupRQsloTJIMo1MATC.jpg")!,
                                                    price: 32217.0,
                                                    title: "Золотое плоское обручальное\n кольцо 4 мм",
                                                    count: 1,
                                                    size: 16,
                                                    sale: 40),
                                      Order.Product(productImage: URL(string: "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoHCBUWFRUXFhQYGBgZGhwaGBgaGhkWGRkcGBoZGRkYGRwcIS4lHB4sHx0aJzgnKy8xNTU1GiQ7Qzs0Py40NTEBDAwMEA8QHhISHjEsJCs3NDE0NTQ0NDo0NDQ0PTQ0NTQ0NDQ0NDQ0PTQ0MTQ0NDQ0NDQ0NDQ0NDQ0NDQ0NDQ0NP/AABEIAOEA4QMBIgACEQEDEQH/xAAbAAEAAgMBAQAAAAAAAAAAAAAABAUBAwYCB//EADsQAAEDAgMGBAQEBAYDAAAAAAEAAhEDIQQSMQUiQVFhcTKBkaGxwdHwBhNCUnKCsuEUI5KiwtIVM2L/xAAYAQEAAwEAAAAAAAAAAAAAAAAAAgMEAf/EACERAQACAgICAwEBAAAAAAAAAAABAgMRITESQRMiUTJx/9oADAMBAAIRAxEAPwD7MiIgIiICIiAiIgIiIMIue2lteo05WNlxJa1oaXb05Wl50AnhI7qzq4vIwOeQ0gb0XAOkDuSAO41Ua2iZ1DtqzERMp6Koo7UzPexrHBzRJD5bPKLH7IW/Z+O/NbmDS25aQSLEa6aqenFgiiYzFCmxzyJDRJgiY81WjbYytc5jgHaBpzH0jqOl005teIoWGxrXg5CDEjs4ag9bjrcKqo7UrfnPY4BobENLTe0mHgxcRHEcVCZivacVm3To0WAVlSREREBERAREQEREBERAREQEREBERAREQYRYJhQKGKL81soGmvqTEeiCkx+Y1hlIbv7xiTEnw/8A1m48FMl7ocC5zjZuZpLGxOrWgTMA3uCPJUG1McWPabmXeLrqJgCLzwGqt/w3tRr2uvJBMA2i/tIg983JUY7atMS05K7pEwlY7CEOzsJa5u8AGuAc6AIfl8TY4c4OoW9u1qYHhqB3L8iuQDxginfituNrNbBMgEwXFxa0cuN5sLakjVaHOP5TnucKVpaXvJbfQuvYHurZmfxm1B/5Om4EObUva2HxBtwBJp9/VRcPh8zw8gwbZMj8rWgy0NDmiHWu7j5BSaNTM3M14qwS1xY/KARwgzfpPFe8JiGPcQJJESQ4mDrlImzhb1B0SJt+GoaK1Mzm3mPZvAsBawi+64HdI8IJN7WhQTUcXtIIcSd8u4tykw0AWNhrwlS/xHtEU6RBO8bRz6HnNrd+S53Z20S95hpO7rpcx/x7+IKrLb7RDTipPjNn0EL0ql+Lc1jXg55A/mJ6gW+HZWVJ8gHmrts+mxERdcEREBERAREQEREBERAREQEREBERBHxZ3HR+0/BUFTFCmN1wE+KwJ6QQVebQcBTdPEEeZsFzQqNygsG90uevdU5La6XYqxbt5wdalUc1j3ZncQ8A5gCLhptFifKdBfZiKFKmYaGNLhlZl3XOJgySDLo06DjyiY3DCplLg8Pb4XZSHN4iIjitFLZ7BUFR5e94EBxBt6z19VX8nGtLvi53vj8XGBqh249+hzFsh1i4wYOnEnlaNF52kGwGuOZrXDIJm9t4yTmjMRflqowI1h89isl4Jk555wV2Ms+OkZwx5bbdktZmqAEtcSA+Cb2BEjoHGTr7LfXqCnLWugOhrSIkwJJJmXWkeQuoQIsQHAjofsIXA3IeTzg9kjLMV0ThibeTbg6FJ5y1MrntAzAnPE6HeuO/1tjEvpUHQ3K136GtgF0AS4id7lJ/bz1gYnBMe9r99r22DgDMffxWp+yaTw7Ox9RzokkOkxpcX91z5NRrSXxRNt74/Fs3HB7CHuzNg2aze6AFpBHkJtwV1sOsH0Q5swS6JBaYzu1BuD0NwqDZmCpUWRka3jB8XnNyV0GxKzXUgW6S7+oqeO0zPKrLWIjhZIiK9QIiICIiAiIgIiICIiAiIgIiICIiCDtMj8sg2mw78FzlXZ2RwljRmvIAgn0sbroKuKkgNbmBmXC7REWnn9Co21qzTDRBIMnpbQ9bqrLFZja3Fa0W1HStwLZqtEmCbiTGjuHp6LpBhWftC5rBV2trAuIaGhxk9BEdfH7KZX/FFITkDnxxaLeomPNRxzWK8rMtbWt9YStqbPLm5qRyvbcNndfzY7vwPA+YPP4+o59IPoucx4khhJ8TDv0njmIPopFX8VOkAMa0nwhxzE9spVJUNYVKlUlrWucHlokgOa2C8aXIAkcYUbXrP8pY6Wj+kzZeJe5rq1Z5Y0gvLJOWmwaQP3FdDsfBucDUqgguAy05MMbwnm86k8NOc8ZlqVAxzHNLA5rnNgtD8hlrXakNmLdFe0vxTVDsjmMc7Uhpg994hRpasf07kpaeKur/AMIz9oXP7WbFYASBlFgSBxvH3otlD8VUyN9jmcybtH81h6So208ZTfVpuY4ODmkGNRlIiQb/AKj6Ky9qzXhXjratuYahgg85cgdMH05+R48l0WyqWVmU6jXlqYAVfsys1rjNpiDpccPNWTcVDoIhtzmNgIPE6Dn6ruKI1tzNa0zr0nIvDXggEGQdCLhe1coEREBERAREQEREBERAREQEREBRsYRkcDxBCkFQRiZeWlrog3jdEGzZ4kiTbSL8Ja2bcwwuDjle9ocd5nCQIkcuCkPMBTNogZ4gWHnBvfrr7Kpx9QxlZ4jZv8XM9G6+nNY78TpupO4idNVLZorvzENJbLW5piYJMWI1BEi8DyW7ZezQyo4PfmMTlc4OgZolu8DEH1IsdF42XX/Jbke573Q3K2Q5xjoJhsze3XgtrqNerVFRrAwg2zb7xAIA3bNseLlKIrqJjmULTfcxM6h72lgqTMhc0uObegZiG2JIk2jmL72isMYQKRlu7lO7aNDEXjUCDeJK01NgVKn/ALKjzeYlrB5ZQT7ra38NNvLnHu+o7/kFZG+dR2hPjqN26eNkGWEZS3XMBlN5MiRY2AvbUqFh8JTfWflbEaOIiTYGHTJaDIvztwVgPwwwAAOIjSHVBH+9aW/h57CTTqPBmfEHz/qb81znjdejddzMT2h7Z2cCGNa/K4kgZTBdAEXLpsTciNR3UXG7IFIipDczQLiS4gzM2vIGpP1MrEYPENqB7w18RwyOsSbOJLbybAhZx20BUZkAfTeToSGmLglnB9jzI9lGfGdzMaTrN41ETuPbZTcC0LRiMzjldUcGCNwce55aWUXZRcz/AC3mS3Q82nTzGh7K7wcZ26Xtfqq68zpZf67nS22SAKbWjgNNY6KeoLsQGlrQ0kQZIExEWPe99LdpnArZEaYZ5nbKIi64IiICIiAiIgIiICIiAiLRiK2UWubQOckBBB2xiIYQJ5mOnD75Kmw9eoBl/McRwOhg3vHGVeOrnJmeMjuUhw7DmfnzCo3ODQqMu4ncS0YdTExp5rVMo+7cyeirtnYKtXeXQWN0aNH5Z1ef0F2pHi4WhXOA2e6oczrN4nt+lvzPNdFRotaAGiAFGuObcz0nfLFeI7V2B2NTYNAeJGgJ5u4uPUq0a0CwsvSK+KxHTLNpt2yiIpOCIiDBCrsbsqnUaQWi/CAR6fSCrJYXJiJ7diZjpwe19l1qUOZvBps1xmebWvN78neqk4OuHtGumhEEdCDoV2FRgIIIkHUFc3tPZZpnOy7eI1Lfq1Zr4/HmGmmWLfWzTWr1GjdfE2zEZiB0lWWwqoa0tJJlznSY1LiT8fZVjHhw+IVzhaoFORBcGxExpz6E8eqlinc8y5mjUaiFsiiYXEZgAQGuicuYExb6j2UtaGYREQEREBERAREQEREHlc1tR/5hzNDsoOXO0xDm8bxz81e4yvlbaCToDx+7KvxuJaWZRGY3MaC8k/26qF9TWU8e4tCrZpJPmVuwOFNV0nwi/lz7nh0lai3Mcvr8APM2XR4PDhjQOOpPX7sqKV8p5aMl/GOO26mwAAAQBoFsRFqZBERAREQEREBERAWCFlEHMbTwf5Ts7Ruu4cjy+i0zIkarpq9IPaWnQrmCwscWHgY+/Y+azXr4zuGrHbyjU9w2bOBa78whzgBd5MxmIEQOUARC6djwQCOKpNnV2tDmu4mROhtoeX91Z4XEZpBgHWBykie2iux68VOXc2S0RFNWIiICIiAiIgIiwgpNtYf8wluUloAmJGptBBB1HDkqyk0AW0AgcbC2p1Vu3aBbnL8pOY5A3i0aSe8qqIsBzMeqoyxG+GnDM60nbIoS7Mf4vWzB6SVfBQNl04aTzJ9Bb5KerKRqqnJO7MoiKaAiIgIiICIiAiIgIiIMKk25h7tcONj3Eke0j0V2om0qeam/oJHldQvG4SpbVolzuawdyup+zMOWuDspiMubmLkRHdQGDUfd1aUcd/lgNyhwgDNOW0CbcNVVi1vloy71wukXlpkL0tDKIiICIiAiIgLBCyiDl8bhshIJkwOcQ52mvRa2jeb5/Aqdtvxfyt/qcoVPxjsVltGrNdJmabl0WC8DP4QfUSpC04TwM/hHwW5aY6ZZ7ZREXXBERAREQEREBERAREQF4e2QRzC9rCDkma+QWyjhs8N5lzbiRcZjN+i8HxeXzKmbM8Tf4z/QVkrG7abLTMV2vaTIaByELYiLWxiIiAiIgIiICIiCj243eB5t/pcP+ygUzvN8/cFW+2qctaeRI9R9QFSh1geUH0Wa/FmvFO6OkwDppt6CP9NvkpKgbLfZzeRkdnX+Mqer6zuGW0amWURFJwREQEREBERAREQEREGF4quhrjyBPoF7ULalSGEcXEN9dfaVyZ1DsRudKAC/ZoU/ZLd5vdx9Bl+agB3iP3Cttj0+PJoHm4yfks1I3ZpyTqq3REWplEREBERAREQEREEfFUszHDmLd9QfWFzQ1I8/XUesrrFz218PlfmGhv8A9h8/MqnLXja7DbnTOzq+VzZ4bjux8J9beq6ALlGuAM8CId2PHyV9s7EZhlJ3mxPUcHeaYrejLX2nIiK5SIiICIiAiIgIiICIiDCodr4iXQNGiP5na+g+JVpjsTkbOpNmjmfoueJk6zE35k6lU5bel2Gu52NZMN569hcrocAyGDmd7109oVNs6hmd0P8ASNfU2XRpir7M1vTKIiuUiIiAiIgIiICIiDCj4zDh7S0+R5FSEXJjcOxOnIwWuLXCCPuFuoVixwjUeHkRxYfkrXauz84zN8Q94+ao2OmQ7XkstqzWWqtovV1GGxDXtkdiOIPIreuWoYhzHSDf2cOTuvVX2DxjagtZw1adR9Qr63ieJUXxzXn0mIiKxWIiICIiAiIgwtdesGAlxgBa8VimsEuPYcT2C5/FYx1R08Bo3gOp5lV2vFf9WUxzb/HrFYhz3Sbch+0fUrSBMNHn2+pWHGLC5P3J6K22XgohztdQD8T8gqKxN5X2tFKpeBw+VtxcxPTkPL6qYiytURqNMszudiIi64IiICIiAiIgIiICIiDCqtqbLD95tnegPfqrVFG1YtGpdraazuHHioQS1zcrhYyj2OF2m40vBHYrpsVg2PFxfgeP9x0VTX2a5t23HmR9W+4VFscw01y1t2h0fxUKZDcQC3gHkQD3cLfBdDhcfTqAFrwZ6rnazARD2iDzALT2OhUBmxmNJNOWTqGk5T5D5QkZLQ7bFW3XDu1lcOP8WzwVWuHI5m/CfdSaO08WPEB3EH4qUZo9wrnBPqYdei5U7TxH3lC1PrV3eJ9uUn5LvzR6g+C3uYdPXxbGeJwHTj6Krxm2SLNaROhdr5NVaykQZzQelvfVemAfpBceMXPmfqoWyWtxHCdcVY5nl4yuccziZPPX+yy58WaJKmUMA52th0083cfL1VrhcCxlwJPPl2HD4rlccy7bLWqJs3Zkbzxfl9forhEWitYrGoZbWm07llERScEREBERAREQEREBERAREQEREBERBGrYVpmRBPEWnvwPmoVTZI/SR7t+FvZWqKM1iUotaOpULtmvGhJ/0n5j4LWcFU5f7XfKV0SKPxQnGWznBgqnL2d8wFtZs151JHk0fM/BXyJ8VSc1lTT2QP1Ge5LvoPYqZSwbW8J76eQFh6KUilFYjpCbWnuQLKIpIiIiAiIgIiICIiAiIgIiICIiAiIgIiICIiAiIgLCIgyiIgIiICIiAiIgIiICIiAiIgIiIP/Z")!,
                                                    price: 32217.0,
                                                    title: "Золотое плоское обручальное\n кольцо 4 мм",
                                                    count: 1,
                                                    size: nil,
                                                    sale: 20)],
                           availableForActive: [Order.Promocode.init(title: "123",
                                                                     percent: 2,
                                                                     endDate: Date(),
                                                                     info: nil,
                                                                     active: false),
                                                Order.Promocode(title: "321",
                                                                percent: 4,
                                                                endDate: Date(),
                                                                info: nil,
                                                                active: false),
                                                Order.Promocode(title: "111",
                                                                percent: 4,
                                                                endDate: Date(),
                                                                info: nil,
                                                                active: false)],
                           paymentDiscount: 1000.0,
                           baseDiscount: 1000.0))
        self.data = order
        updatedPromocodes = order.promocodes
        self.displayedPromocodes = updatedPromocodes
        isDataCorrect()
        setupDataForBottomView()
    }
    
    func handleSwitch(_ isOn: Bool, indexPath: Int) {
        guard indexPath < displayedPromocodes.count else { return }
        let promocode = displayedPromocodes[indexPath]
        
        if let updatedIndex = updatedPromocodes.firstIndex(where: { $0.title == promocode.title }) {
            updatedPromocodes[updatedIndex].active = isOn
            displayedPromocodes[indexPath].active = isOn
            
            if isOn {
                if countOfChoosenPromocodes < 2 {
                    countOfChoosenPromocodes += 1
                    data?.promocodes[indexPath].active = true
                    applyDiscount(promocode)
                } else {
                    isForcingToggle = true
                    errorMessage = ErrorMessages.moreThanTwoCurrentActivatedPromocodes
                    updatedPromocodes[updatedIndex].active = false
                    displayedPromocodes[indexPath].active = false
                    data?.promocodes[indexPath].active = false
                }
            } else {
                if isForcingToggle {
                    isForcingToggle = false
                } else {
                    countOfChoosenPromocodes -= 1
                    data?.promocodes[indexPath].active = false
                    removeDiscount(promocode)
                    
                    if !errorMessage.isEmpty {
                        errorMessage = ""
                    }
                  
                }
            }
            
            if let data = data {
                delegate?.setData(data)
            }
        }
    }


    
    func hidePromocodesAction() {
        guard var data = data else { return }
        
        if isPromocodesHidden {
            displayedPromocodes = updatedPromocodes
            isPromocodesHidden = false
        } else {
            let activePromocodes = updatedPromocodes.filter { $0.active }
            
            switch activePromocodes.count {
            case 2:
                let inactivePromocodes = updatedPromocodes.filter { !$0.active }.prefix(1)
                displayedPromocodes = Array(activePromocodes.prefix(2)) + Array(inactivePromocodes)
                
            case 1:
                let inactivePromocodes = updatedPromocodes.filter { !$0.active }.prefix(2)
                displayedPromocodes = [activePromocodes.first!] + Array(inactivePromocodes)
                
            default:
                displayedPromocodes = Array(updatedPromocodes.prefix(3))
            }
            
            isPromocodesHidden = true
        }
        data.promocodes = displayedPromocodes
        delegate?.didHidePromocode(data, isActive: isPromocodesHidden)
        recalculateTotalSum()
    }
    
    
    func showNextController() {
        guard let data = data else { return }
        delegate?.showController(data)
    }
    
}

private extension OrderViewModel {
    
    func isDataCorrect() {
        if let data = data {
            if data.products.isEmpty {
                errorMessage = ErrorMessages.emptyProducts
            }
            
            data.products.forEach {
                if $0.sale > 100 {
                    fatalError()
                }
            }
            if data.payment.isEmpty {
                fatalError()
            }
            
            if data.payment.count > 6 {
                fatalError()
            }
            
            data.promocodes.forEach {
                if $0.active == true {
                    countOfChoosenPromocodes += 1
                    if countOfChoosenPromocodes > 2 {
                        countOfChoosenPromocodes = 2
                        errorMessage = ErrorMessages.invalidCountActivatedPromocodes
                    }
                }
            }
            
            data.products.forEach {
                if $0.price <= 0 {
                    errorMessage = ErrorMessages.invalidProductsCost
                }
            }
            
            for dataProd in data.products {
                if dataProd.price < data.baseDiscount ?? 0 {
                    errorMessage = ErrorMessages.invalidBaseDiscount
                }
            }
        } else {
            errorMessage = ErrorMessages.cantGetData
        }
    }
    
    func setupDataForBottomView() {
        guard let data = data else {
            errorMessage = ErrorMessages.cantGetProductsData
            return
        }
        totalSumMain = data.products.reduce(0) { $0 + $1.discountPrice }
        fixedDiscount = data.baseDiscount ?? 0
        paymentDiscount = data.paymentDiscount ?? 0
        
        activePromocodes = data.promocodes.filter { $0.active }
        recalculateTotalSum()
    }
    
    func applyDiscount(_ promocode: Order.Promocode) {
        activePromocodes.append(promocode)
        recalculateTotalSum()
    }
    
    func removeDiscount(_ promocode: Order.Promocode) {
        activePromocodes.removeAll { $0.title == promocode.title }
        recalculateTotalSum()
    }
    
    func recalculateTotalSum() {
        let discountSum = activePromocodes.reduce(0) {
            $0 + (totalSumMain * Double($1.percent) / 100)
        }
        totalSum = totalSumMain - discountSum - fixedDiscount - paymentDiscount
    }
    
    func notifyUpdate() {
        totalDiscount = activePromocodes.reduce(0) {
            $0 + (totalSumMain * Double($1.percent) / 100)
        }
        delegate?.didUpdateTotalSum(totalSum, totalDiscount: totalDiscount)
    }
}

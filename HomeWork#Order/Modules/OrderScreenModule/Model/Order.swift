

import Foundation

struct Order {
    
    struct Promocode {
        let title: String
        let percent: Int
        let endDate: Date?
        let info: String?
        var active: Bool
    }
    
    struct Product {
        let productImage: URL
        let price: Double
        let discountPrice: Double
        let title: String
        let count: Int
        let size: Double?
        let sale: Int
        
        init(productImage: URL, price: Double, title: String, count: Int, size: Double?, sale: Int) {
            self.productImage = productImage
            self.price = price
            self.discountPrice = price - (price * Double(sale) / 100)
            self.title = title
            self.count = count
            self.size = size
            self.sale = sale
        }
    }
    
    struct PaymentType {
        let paymentImage: String
        let title: String
        let description: String
        let sale: Int?
        let additionalBenefits: AdditionalBenefits?
    }
    
    struct AdditionalBenefits {
        let image: String
        let bonusPercent: Int
    }
    
    var screenTitle: String
    var promocodes: [Promocode]
    
    let payment: [PaymentType]
    let products: [Product]
    let availableForActive: [Promocode]?
    let paymentDiscount: Double?
    let baseDiscount: Double?
}

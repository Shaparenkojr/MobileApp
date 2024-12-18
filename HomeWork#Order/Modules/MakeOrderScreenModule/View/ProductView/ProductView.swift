//
//  ProductView.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 13.12.2024.
//

import SwiftUI

struct ProductView: View {
    
    private enum Colors {
        static let procentSaleBackgroundColor: Color = Color(red: 255.0 / 255.0,
                                                             green: 70.0 / 255.0,
                                                             blue: 17.0 / 255.0)
    }
    
    let productData: Order.Product
    
    var body: some View {
        HStack(alignment: .top) {
            
            AsyncImage(url: productData.productImage) { image in
                image.image?.resizable().scaledToFill().frame(width: 80, height: 80)
            }
          
            VStack(alignment: .leading) {
                Text(productData.title)
                    .font(Font.system(size: 14))
                if let size = productData.size {
                    Text("\(productData.count) шт. • Размер: \(String(format: "%.0f", size))")
                        .font(Font.system(size: 14))
                } else {
                    Text("\(productData.count) шт.")
                        .font(Font.system(size: 14))
                }
                HStack {
                    Text("\(formattedPrice(productData.price)) ₽")
                        .font(Font.system(size: 14))
                        .strikethrough()
                    Text("-\(productData.sale)%")
                        .font(Font.system(size: 12))
                        .foregroundStyle(Color.red)
                        .frame(maxWidth: 40, maxHeight: 18)
                        .background(Colors.procentSaleBackgroundColor.opacity(0.1))
                        .cornerRadius(5)
                }
                Text("\(formattedPrice(productData.discountPrice)) ₽")
                    .font(Font.system(size: 16))
                    .bold()
            }
        }
    }
    
    private func formattedPrice(_ price: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
        }
}

//#Preview {
//    ProductView()
//}

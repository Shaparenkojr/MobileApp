

import SwiftUI

struct PaymentView: View {
    
    let paymentData: Order.PaymentType
    
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Image(paymentData.paymentImage).padding(.leading, 12)
            VStack(alignment: .leading) {
                HStack {
                    Text(paymentData.title)
                    if let sale = paymentData.sale {
                        Text("-\(sale)%")
                            .frame(maxWidth: 37, maxHeight: 20, alignment: .center)
                            .foregroundStyle(Color.white)
                            .font(Font.system(size: 12))
                            .background(Color.black)
                            .cornerRadius(10, corners: [.topLeft,
                                                        .bottomRight,
                                                        .topRight,
                                                        .bottomLeft])
                    }
                    if let additionalBenefits = paymentData.additionalBenefits {
                        Text("+\(additionalBenefits.bonusPercent)% \(Image(additionalBenefits.image))")
                            .frame(maxWidth: 49, maxHeight: 20, alignment: .center)
                            .foregroundStyle(Color.white)
                            .font(Font.system(size: 12))
                            .background(Color.green)
                            .cornerRadius(10, corners: [.topLeft,
                                                        .bottomRight,
                                                        .topRight])
                    }
                }
                Text(paymentData.description)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button {
                self.isSelected.toggle()
            } label: {
                if isSelected {
                    Image("paymentOn")
                } else {
                    Image("paymentOff")
                }
            }
            .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: 70)
        .background(Color.white)
        .cornerRadius(isSelected ? 10 : 0)
        .shadow(color: Color.black.opacity(0.2), radius: isSelected ? 10 : 0)
//        .padding([.leading, .trailing], 16)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

//#Preview {
//    PaymentView(paymentData: Order.PaymentType(paymentImage: "sberbank", title: "fsdfdsf", description: "fdsfs", sale: 5, additionalBenefits: nil), isSelected: false)
//}

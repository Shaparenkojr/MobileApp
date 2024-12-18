

import SwiftUI

struct TotalPriceView: View {
    
    @Binding var totalSum: Double
    @Binding var totalDiscountSum: Double
    
    @Binding var isPresentingModal: Bool
    
    @State private var randomContent: ModalContent = .success
    
    let totalSumMain: Double
    let fixedDiscount: Double
    let paymentDiscount: Double
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Цены за 2 товара")
                    Spacer()
                    Text("\(Int(totalSumMain)) ₽")
                }
                
                HStack {
                    Text("Скидки")
                    Spacer()
                    Text("-\(Int(fixedDiscount)) ₽")
                        .foregroundStyle(Color.red)
                }
                .padding(.top, 8)
                
                HStack {
                    HStack {
                        Text("Промокоды")
                        Image("info_circle")
                    }
                    Spacer()
                    Text("-\(Int(totalDiscountSum)) ₽")
                        .foregroundStyle(Color.green)
                }
                .padding(.top, 8)
                
                HStack {
                    Text("Способ оплаты")
                    Spacer()
                    Text("-\(Int(paymentDiscount)) ₽")
                }
                .padding(.top, 8)
            }
            .padding([.leading, .trailing], 26)
            .padding(.top, 16)
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width - 60, height: 1)
                .foregroundStyle(Color.gray.opacity(0.3))
            
            HStack {
                Text("Итого")
                    .padding(.leading, 16)
                Spacer()
                Text("\(Int(totalSum)) ₽")
                    .padding(.trailing, 16)
            }
            .padding([.leading, .trailing, .top], 16)
            
            Button {
                randomContent = [ModalContent.success, .warning, .paymentFailed, .error].randomElement()!
                isPresentingModal.toggle()
            } label: {
                Text("Оплатить")
                    .frame(maxWidth: 311, maxHeight: 54)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.red)
            .fullScreenCover(isPresented: $isPresentingModal) {
                ResultView(isPresented: $isPresentingModal, content: randomContent)
            }
            
            Group {
                Text("Нажимая кнопку «Оформить заказ», \nВы соглашаетесь с ") +
                Text("Условиями оферты")
                    .bold()
            }
            .multilineTextAlignment(.center)
            .frame(alignment: .center)
            .font(Font.system(size: 12))
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
    }
}

//#Preview {
//    TotalPriceView()
//}

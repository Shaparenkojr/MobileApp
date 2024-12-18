

import SwiftUI

enum ModalContent {
    case success
    case warning
    case paymentFailed
    case error
    
    var image: String {
        switch self {
        case .success: return "successOrder"
        case .warning: return "successOrder"
        case .paymentFailed: return "paymentError"
        case .error: return "orderError"
        }
    }
    
    var title: String {
        switch self {
        case .success: return "Спасибо за заказ!"
        case .warning: return "Спасибо за заказ!"
        case .paymentFailed: return "Оплата не прошла"
        case .error: return "Что-то пошло не так"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "Заказ успешно оформлен. Вы можете отслеживать его статус в личном кабинете."
        case .warning:
            return "Обратите внимание, что у неоплаченных заказов ограниченный срок хранения."
        case .paymentFailed:
            return "Возможно, были введены неверные данные или произошла ошибка на стороне платежной системы."
        case .error:
            return "К сожалению, ваш заказ не был создан."
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
        case .success: return "Продолжить покупки"
        case .warning: return "Продолжить покупки"
        case .paymentFailed: return "Попробовать еще раз"
        case .error: return "На главную"
        }
    }
    
    var secondaryButtonTitle: String? {
        switch self {
        case .success, .warning: return "Статус заказа"
        case .paymentFailed, .error: return nil
        }
    }
}


struct ResultView: View {
    @Binding var isPresented: Bool
    let content: ModalContent
    
    var body: some View {
        NavigationView {
            VStack {
                Image(content.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding()
                
                Text(content.title)
                    .font(.largeTitle)
                    .padding(.top)
                    .bold()
                
                Text(content.message)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .font(Font.system(size: 14))
                    .foregroundStyle(Color.gray)
                    .padding(.top, 8)
                
                VStack(spacing: 16) {
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Text(content.primaryButtonTitle)
                            .frame(maxWidth: 280, maxHeight: 54)
                            .foregroundStyle(Color.white)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(Color.red)
                    
                    if let secondaryTitle = content.secondaryButtonTitle {
                        Button(secondaryTitle) {
                        }
                        .buttonStyle(.bordered)
                        .foregroundStyle(Color.red)
                        .tint(Color.clear)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

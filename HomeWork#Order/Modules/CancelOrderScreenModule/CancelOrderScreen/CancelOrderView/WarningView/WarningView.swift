

import SwiftUI

struct WarningView: View {
    
    private enum Constants {
        static let warningViewColor: Color = Color(red: 254.0 / 255.0, green: 247.0 / 255.0, blue: 222.0 / 255.0)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: 343, maxHeight: 85)
                .foregroundStyle(Constants.warningViewColor)
                .cornerRadius(10)
            HStack {
                Text("Обычно деньги сразу возвращаются на карту. В некоторых случаях это может занять до 3 рабочих дней.")
                    .font(Font.system(size: 14, weight: .regular))
                    .padding()
                Image("warningMark")
                    .padding(.bottom, 29)
                    .padding(.trailing, 8)
            }
            .padding()
        }
        .padding(.bottom, 8)
    }
}

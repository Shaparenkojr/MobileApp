

import SwiftUI

struct ErrorView: View {
    
    private enum Constants {
        static let errorViewColor: Color = Color(red: 255.0 / 255.0, green: 235.0 / 255.0, blue: 236.0 / 255.0)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: 343, maxHeight: 48)
                .cornerRadius(10)
                .foregroundStyle(Constants.errorViewColor)
            HStack {
                Text("Пожалуйста выберите причину!")
                    .foregroundStyle(Color.red)
                    .font(Font.system(size: 14,
                                      weight: .semibold))
                    .padding()
                Spacer()
                Image("errorMark")
                    .padding(.trailing, 16)
            }
            .padding()
        }
    }
}

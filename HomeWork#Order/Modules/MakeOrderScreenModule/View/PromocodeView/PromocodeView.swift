

import SwiftUI

struct PromocodeView: View {
    
    @Binding var promocodeData: Order.Promocode
    @Binding var isTurn: Bool
    var onToggleChange: ((Order.Promocode, Bool) -> Void)?
    
    var body: some View {
        HStack {
            RoundedCorner()
                .frame(width: 16, height: 16)
                .padding(.leading, -8)
                .foregroundStyle(Color.white)
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(promocodeData.title)
                        .lineLimit(nil)
                        .font(Font.system(size: 16))
                    Text("-\(promocodeData.percent)%")
                        .frame(maxWidth: 37, maxHeight: 20)
                        .background(Color.green)
                        .cornerRadius(10)
                        .font(Font.system(size: 12))
                        .foregroundColor(Color.white)
                    Image("info_circle")
                        .padding(.top, 1)
                }
                if let endDate = promocodeData.endDate {
                    Text("\(formatDate(endDate))")
                        .font(Font.system(size: 14))
                }
                
                if let description = promocodeData.info {
                    Text(description)
                        .font(Font.system(size: 12))
                }
            }
            .padding([.top, .leading, .bottom], 16)
            Spacer()
            
            Toggle("", isOn: $isTurn)
                .labelsHidden()
                .padding()
                .onChange(of: isTurn) { oldValue, newValue in
                    onToggleChange?(promocodeData, newValue)
                }
            
            RoundedCorner()
                .frame(width: 16, height: 16)
                .padding(.trailing, -8)
                .foregroundStyle(Color.white)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        
    }
}

private extension PromocodeView {
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "'По' d MMMM"
        return formatter.string(from: date)
    }
}

//#Preview {
//    PromocodeView()
//}

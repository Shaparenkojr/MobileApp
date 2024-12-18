

import SwiftUI

struct ListItem: View {
    
    @Binding var isTicked: Bool
    let itemName: String
    
    var body: some View {
        HStack {
            Button {
                self.isTicked.toggle()
            } label: {
                if isTicked {
                    Image("onCheckbox")
                } else {
                    Image("offCheckbox")
                }
            }
            Text("\(itemName)")
        }
    }
}

//#Preview {
//    ListItem(itemName: "kek")
//}

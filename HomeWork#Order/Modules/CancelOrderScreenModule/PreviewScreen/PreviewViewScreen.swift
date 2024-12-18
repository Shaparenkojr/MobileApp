

import SwiftUI

struct PreviewViewScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    CancelOrderView()
                } label: {
                    Text("Move to cancel order view")
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .padding()
        }
    }
}

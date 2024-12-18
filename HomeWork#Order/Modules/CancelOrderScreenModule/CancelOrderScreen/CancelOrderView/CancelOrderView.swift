
import SwiftUI

struct CancelOrderView: View {
    
    private enum Constants {
        static let buttonBackgroundColor: Color = Color(red: 255.0 / 255.0, green: 70.0 / 255.0, blue: 17.0 / 255.0)
        static let problemTextFieldPlaceholde: String = "Опишите проблему"
        static let cancelOrderButtonTitle: String = "Отменить заказ"
        static let screenTitleBar: String = "Укажите причину отказа"
    }
    
    private var listViewContent: [String] = ["Не подходит дата получения",
                                             "Часть товаров из заказа была отменена",
                                             "Не получилось применить скидку или промокод",
                                             "Хочу изменить заказ и оформить заново",
                                             "Нашелся товар дешевле",
                                             "Другое"]
    
    @State private var selectedItemIndex: Int? = nil
    @State private var errorViewIsHidden: Bool = true
    @State private var userProblemInput = ""
    @State private var snackBarIsHidden = true
    @State private var loaderIsHidden: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            if !errorViewIsHidden {
                ErrorView()
                .transition(.opacity.combined(with: .slide))
            }
            
            List {
                ForEach(listViewContent.indices, id: \.self) { index in
                    ListItem(
                        isTicked: Binding(
                            get: { selectedItemIndex == index },
                            set: { isSelected in
                                selectedItemIndex = isSelected ? index : nil
                                withAnimation {
                                    errorViewIsHidden = true
                                }
                            }
                        ), itemName: listViewContent[index]
                    )
                    .listRowSeparator(.hidden)
                }
                if selectedItemIndex == listViewContent.count - 1 &&
                    listViewContent[listViewContent.count - 1] == "Другое" {
                    TextField(Constants.problemTextFieldPlaceholde, text: $userProblemInput)
                        .padding()
                        .frame(maxWidth: 343, maxHeight: 54)
                        .listRowSeparator(.hidden)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .transition(.opacity.combined(with: .slide))
                }
            }
            .animation(.easeInOut, value: selectedItemIndex)
            .listStyle(.inset)
            
            WarningView()
            
            Button {
                withAnimation {
                    if selectedItemIndex == nil {
                        errorViewIsHidden = false
                    } else {
                        withAnimation {
                            loaderIsHidden = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation {
                                loaderIsHidden = true
                                snackBarIsHidden = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation {
                                    selectedItemIndex = nil
                                    snackBarIsHidden = true
                                }
                            }
                        }
                    }
                }
            } label: {
                Text(Constants.cancelOrderButtonTitle)
                    .frame(maxWidth: 343, maxHeight: 50)
                    .contentShape(Rectangle())
            }
            .font(.headline)
            .foregroundColor(.white)
            .background(Constants.buttonBackgroundColor)
            .cornerRadius(10)
            
            if !snackBarIsHidden {
                SnackBarView()
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 16)
        .navigationTitle(Constants.screenTitleBar)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if !loaderIsHidden {
                ProgressView()
                    .progressViewStyle(.circular)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    CancelOrderView()
}

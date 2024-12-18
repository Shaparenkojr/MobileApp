
import SwiftUI
import Combine

struct MakeOrderView: View {
    
    private enum Colors {
        static let promocodesButtonBackgroundColor: Color = Color(red: 255.0 / 255.0,
                                                                  green: 70.0 / 255.0,
                                                                  blue: 17.0 / 255.0)
    }
    
    @ObservedObject var viewModel: MakeOrderViewModel = MakeOrderViewModel()
    
    @State private var selectedIndex: Int? = nil
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Состав заказа")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 4)
                        Group {
                            Text("Вы можете изменить параметры и состав заказа в ")
                                .foregroundStyle(Color.gray) +
                            Text("корзине")
                                .foregroundStyle(Color.red)
                        }
                        .font(Font.system(size: 14))
                    }
                    .padding(.vertical, 8)
                    ForEach(viewModel.orderData.indices, id: \.self) { index in
                        ProductView(productData: viewModel.orderData[index])
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 16)
                        .foregroundStyle(Color.gray.opacity(0.2))
                }
                .listRowSeparator(.hidden)
                
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Способ оплаты")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 4)
                    }
                    .padding(.vertical, 8)
                    ForEach(viewModel.paymentData.indices, id: \.self) { paymentIndex in
                        HStack {
                            PaymentView(paymentData: viewModel.paymentData[paymentIndex], isSelected: Binding(
                                get: {
                                    selectedIndex == paymentIndex
                                }, set: { isSelected in
                                    selectedIndex = isSelected ? paymentIndex : nil
                                })
                            )
                        }
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 16)
                        .foregroundStyle(Color.gray.opacity(0.2))
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listSectionSpacing(20)
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Промокоды")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 4)
                        Text("На один товар можно применить только один промокод")
                            .font(Font.system(size: 14))
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.vertical, 8)
                    
                    Button {
                        print("nothing")
                    } label: {
                        Text("\(Image("promocode"))  Применить промокод")
                            .frame(width: 343, height: 54, alignment: .center)
                            .foregroundStyle(Color.red)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Colors.promocodesButtonBackgroundColor.opacity(0.1))
                    
                    ForEach(viewModel.promocodeData.indices, id: \.self) { promocodeIndex in
                        PromocodeView(
                            promocodeData: $viewModel.promocodeData[promocodeIndex],
                            isTurn: $viewModel.promocodeData[promocodeIndex].active) { _ , isActive in
                                viewModel.activatePromocode(isOn: isActive, at: promocodeIndex)
                        }
                    }
                    
                    Button {
                        print("still nothing")
                    } label: {
                        Text("Скрыть промокоды")
                            .foregroundStyle(Color.red)
                            .bold()
                    }
                    .buttonStyle(.plain)

                }
                .listRowSeparator(.hidden)
                .headerProminence(.increased)
                
                
                Section {
                    TotalPriceView(totalSum: Binding<Double>.constant(viewModel.finalSumWithSales),
                                   totalDiscountSum: Binding<Double>.constant(viewModel.totalDiscountPromocodes),
                                   isPresentingModal: $viewModel.isPresentedModal,
                                   totalSumMain: viewModel.totalPriceForProducts,
                                   fixedDiscount: viewModel.fixedDiscounts["fixedDiscount"] ?? 0,
                                   paymentDiscount: viewModel.fixedDiscounts["paymentDiscount"] ?? 0)
                }
                .listSectionSeparator(.hidden)
                .padding([.leading, .trailing], -26)
            }
            .listStyle(.inset)
            .scrollIndicators(.hidden)
            .alert(isPresented: Binding<Bool>(
                get: { !viewModel.errorMessage.isEmpty },
                set: { if !$0 { viewModel.errorMessage = "" } }
            )) {
                Alert(
                    title: Text("Ошибка"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Оформить заказ")
    }
}

#Preview { MakeOrderView() }

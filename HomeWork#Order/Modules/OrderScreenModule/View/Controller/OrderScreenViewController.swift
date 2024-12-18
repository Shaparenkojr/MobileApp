

import UIKit

final class OrderScreenViewController: UIViewController {
    
    private enum Constants {
        static let controllerTitle = "Оформление заказа"
        static let alertOkButtonTitle = "OK"
    }
    
    private lazy var orderScreenView: OrderScreenView = {
        let view = OrderScreenView(frame: .zero, viewModel: orderViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderViewModel: OrderViewModel
    
    init(orderViewModel: OrderViewModel) {
        self.orderViewModel = orderViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        orderViewModel.delegate = self
        orderViewModel.setData()
    }
    
    func reloadOrderData(_ data: Order) {
        orderViewModel.udpateOrderData(data)
        orderScreenView.updateLayoutSubviews()
    }
    
}

extension OrderScreenViewController: OrderViewModelDelegate {
    
    func setData(_ data: Order) {
        orderScreenView.showOrder(data)
    }
    
    func showAlert(_ alertTitle: String, _ alertMessage: String) {
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: Constants.alertOkButtonTitle,
                                     style: .cancel)
        alert.addAction(okButton)
        
        if alertMessage == ErrorMessages.cantGetProductsData {
            orderScreenView.showErrorLabel(for: UIType.bottomView)
        }
        
        if alertMessage == ErrorMessages.cantGetData {
            orderScreenView.showErrorLabel(for: UIType.uiview)
        }
        self.present(alert, animated: true)
    }
    
    func countOfChoosenPromocodesDidChanged(_ count: Int) {
        if count == 3 {
            orderScreenView.showErrorLabel(for: UIType.tableView)
        }
    }
    
    func isActiveCellDidChanged(_ index: Int) {
        orderScreenView.updateTableViewCellSwitch(for: index)
    }
    
    func didUpdateTotalSum(_ totalSum: Double, totalDiscount: Double) {
        orderScreenView.updateBottomViewUI(totalSum: totalSum, totalDiscount: Int(totalDiscount))
    }
    
    func didHidePromocode(_ data: Order, isActive: Bool) {
        orderScreenView.showOrder(data)
        orderScreenView.updateLayoutSubviews()
        orderScreenView.changeHideButtonTitle(on: isActive)
    }
    
    func showController(_ data: Order) {
        let newPromocodeViewModel = NewPromocodeViewModel(data: data)
        let newPromocodeViewController = NewPromocodeViewController(viewModel: newPromocodeViewModel)
        self.navigationController?.pushViewController(newPromocodeViewController, animated: true)
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backItem.tintColor = .orange
        self.navigationItem.backBarButtonItem = backItem
    }
    
    func showSnackView() {
        let snackView = SnackView()
        snackView.translatesAutoresizingMaskIntoConstraints = false
        snackView.alpha = 0
        view.addSubview(snackView)
        
        NSLayoutConstraint.activate([
            snackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            snackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            snackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26),
            snackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 0.3, animations: {
            snackView.alpha = 0.5
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.3, animations: {
                    snackView.alpha = 0
                }) { _ in
                    snackView.removeFromSuperview()
                }
            }
        }
    }
}

private extension OrderScreenViewController {
    
    func setupController() {
        setupNavigationTitle()
        view.addSubview(orderScreenView)
        
        view.backgroundColor = .white
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            orderScreenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            orderScreenView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            orderScreenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            orderScreenView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = Constants.controllerTitle
        
        let customTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        titleLabel.frame = CGRect(x: 25, y: 9, width: 200, height: 40)
        customTitleView.addSubview(titleLabel)
        
        navigationItem.titleView = customTitleView
    }
}


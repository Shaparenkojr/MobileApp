

import UIKit
import SwiftUI
import Combine

final class StartScreenViewController: UIViewController {
    
    private lazy var startView: StartScreenView = {
        let view = StartScreenView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: StartScreenViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
    
    init(viewModel: StartScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StartScreenViewController {
    
    func setupBindings() {
        viewModel.navigationSubscribtion
            .sink { buttonIdentifier in
                self.showChoosenScreen(choosenScreen: buttonIdentifier)
            }
            .store(in: &subscriptions)
    }
    
    func showChoosenScreen(choosenScreen: ButtonIdentifier) {
        switch choosenScreen {
        case .defaultType:
            break
        case .enterPromocode:
            let viewModel = OrderViewModel()
            let orderScreen = OrderScreenViewController(orderViewModel: viewModel)
//            let viewModel = NewPromocodeViewModel(data: nil)
//            let newPromocodeScreen = NewPromocodeViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(orderScreen, animated: true)
        case .review:
            let productsScreen = ProductsListViewController()
            self.navigationController?.pushViewController(productsScreen, animated: true)
        case .cancelOrder:
            let cancelOrderScreen = CancelOrderView()
            self.navigationController?.pushViewController(UIHostingController(rootView: cancelOrderScreen), animated: true)
        case .order:
            let makeOrderScreen = MakeOrderView()
            self.navigationController?.pushViewController(UIHostingController(rootView: makeOrderScreen), animated: true)
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = UIColor.orange
        }
    }
    
    func setupController() {
        view.backgroundColor = .white
        
        view.addSubview(startView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            startView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            startView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            startView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            startView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

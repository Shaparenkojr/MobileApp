

import UIKit
import Foundation

final class NewPromocodeViewController: UIViewController {
    
    private enum Constants {
        static let controllerTitle = "Применить промокод"
    }
    
    private lazy var newPromocodeView: NewPromocodeView = {
        let view = NewPromocodeView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: NewPromocodeViewModel
    
    init(viewModel: NewPromocodeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
}

extension NewPromocodeViewController: NewPromocodeViewModelDelegate {
    
    func showError(errorMessage: String) {
        newPromocodeView.showErrorLabel(errorMessage)
    }
    
    func popToPreviouesController(_ newData: Order) {
        let newOrderData = newData
        if let previousController = self.navigationController?.viewControllers.last(where: { $0 is OrderScreenViewController }) as? OrderScreenViewController {
            previousController.reloadOrderData(newOrderData)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

private extension NewPromocodeViewController {
    
    func setupController() {
        title = Constants.controllerTitle
        view.backgroundColor = .white
        
        view.addSubview(newPromocodeView)
        
        viewModel.delegate = self
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            newPromocodeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newPromocodeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newPromocodeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newPromocodeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

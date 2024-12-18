

import UIKit

final class ProductsListViewController: UIViewController {
    
    private enum Constants {
        static let controllerTitle = "Напишите отзыв"
    }
    
    private lazy var productsListView: ProductsListView = {
        let view = ProductsListView(frame: .zero, viewModel: viewModel)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel = ProductsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        
        viewModel.dataDidChanged = { [weak self] data in
            self?.productsListView.setProductsData(data)
        }
        
        viewModel.getData()
    }
}

extension ProductsListViewController: IProductsListView {
    
    func didCellTapped(selectedCell: Product) {
        let reviewViewModel = ReviewProductViewModel(productData: selectedCell)
        let reviewProductViewController = ReviewProductViewController(viewModel: reviewViewModel)
        self.navigationController?.pushViewController(reviewProductViewController, animated: true)
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backItem.tintColor = .orange
        self.navigationItem.backBarButtonItem = backItem
    }
}

private extension ProductsListViewController {
    
    func setupController() {
        view.backgroundColor = .white
        title = Constants.controllerTitle
        
        view.addSubview(productsListView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productsListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productsListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productsListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productsListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

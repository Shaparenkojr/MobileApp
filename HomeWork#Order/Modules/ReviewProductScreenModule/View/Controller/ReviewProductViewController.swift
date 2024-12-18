

import Foundation
import UIKit

final class ReviewProductViewController: UIViewController {
    
    private lazy var reviewProductView: ReviewProductView = {
        let view = ReviewProductView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: ReviewProductViewModel
    
    init(viewModel: ReviewProductViewModel) {
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

private extension ReviewProductViewController {
    
    func setupController() {
        view.backgroundColor = .white
        view.addSubview(reviewProductView)
        title = "Напишите отзыв"
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            reviewProductView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            reviewProductView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            reviewProductView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            reviewProductView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

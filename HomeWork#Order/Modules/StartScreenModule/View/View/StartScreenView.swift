

import UIKit

final class StartScreenView: UIView {
    
    private lazy var contentButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var enterPromocodeNavigationButton: UIButton = createNavigateButton(title: ButtonIdentifier.enterPromocode.rawValue)
    private lazy var reviewNavigationButton: UIButton = createNavigateButton(title: ButtonIdentifier.review.rawValue)
    private lazy var cancelOrderNavigationButton: UIButton = createNavigateButton(title: ButtonIdentifier.cancelOrder.rawValue)
    private lazy var orderNavigationButton: UIButton = createNavigateButton(title: ButtonIdentifier.order.rawValue)
    
    private let viewModel: StartScreenViewModel
    
    init(frame: CGRect, viewModel: StartScreenViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StartScreenView {
    
    func createNavigateButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(navigateButtonAction), for: .touchUpInside)
        return button
    }
    
    @objc
    func navigateButtonAction(_ button: UIButton) {
        let buttonIdentifier: ButtonIdentifier = ButtonIdentifier(rawValue: button.titleLabel?.text ?? "") ?? ButtonIdentifier.defaultType
        
        switch buttonIdentifier {
        case .enterPromocode:
            viewModel.navigateToNextScreen(clickedButtonType: .enterPromocode)
        case .review:
            viewModel.navigateToNextScreen(clickedButtonType: .review)
        case .cancelOrder:
            viewModel.navigateToNextScreen(clickedButtonType: .cancelOrder)
        case .order:
            viewModel.navigateToNextScreen(clickedButtonType: .order)
        case .defaultType:
            break
        }
    }
    
    func setupView() {
        backgroundColor = .clear
        
        addSubview(contentButtonsView)
        
        contentButtonsView.addSubview(enterPromocodeNavigationButton)
        contentButtonsView.addSubview(reviewNavigationButton)
        contentButtonsView.addSubview(cancelOrderNavigationButton)
        contentButtonsView.addSubview(orderNavigationButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentButtonsView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentButtonsView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentButtonsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            enterPromocodeNavigationButton.topAnchor.constraint(equalTo: contentButtonsView.topAnchor, constant: 16),
            enterPromocodeNavigationButton.leadingAnchor.constraint(equalTo: contentButtonsView.leadingAnchor, constant: 8),
            enterPromocodeNavigationButton.trailingAnchor.constraint(equalTo: contentButtonsView.trailingAnchor, constant: -8),
            enterPromocodeNavigationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            reviewNavigationButton.topAnchor.constraint(equalTo: enterPromocodeNavigationButton.bottomAnchor, constant: 16),
            reviewNavigationButton.leadingAnchor.constraint(equalTo: contentButtonsView.leadingAnchor, constant: 8),
            reviewNavigationButton.trailingAnchor.constraint(equalTo: contentButtonsView.trailingAnchor, constant: -8),
            reviewNavigationButton.heightAnchor.constraint(equalTo: enterPromocodeNavigationButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cancelOrderNavigationButton.topAnchor.constraint(equalTo: reviewNavigationButton.bottomAnchor, constant: 16),
            cancelOrderNavigationButton.leadingAnchor.constraint(equalTo: contentButtonsView.leadingAnchor, constant: 8),
            cancelOrderNavigationButton.trailingAnchor.constraint(equalTo: contentButtonsView.trailingAnchor, constant: -8),
            cancelOrderNavigationButton.heightAnchor.constraint(equalTo: enterPromocodeNavigationButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            orderNavigationButton.topAnchor.constraint(equalTo: cancelOrderNavigationButton.bottomAnchor, constant: 16),
            orderNavigationButton.leadingAnchor.constraint(equalTo: contentButtonsView.leadingAnchor, constant: 8),
            orderNavigationButton.trailingAnchor.constraint(equalTo: contentButtonsView.trailingAnchor, constant: -8),
            orderNavigationButton.bottomAnchor.constraint(equalTo: contentButtonsView.bottomAnchor, constant: -16),
            orderNavigationButton.heightAnchor.constraint(equalTo: enterPromocodeNavigationButton.heightAnchor)
        ])
    }
}

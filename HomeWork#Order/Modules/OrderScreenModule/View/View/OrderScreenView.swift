

import Foundation
import UIKit

// MARK: - OrderScreenView Class
final class OrderScreenView: UIView {
    
    private enum Constants {
        static let promocodeInfoLabelText = "На один товар можно применить только один промокод"
        static let activePromocodesButtonTitle = "Применить промокод"
        static let activePromocodeButtonImage = UIImage(named: "promocode")
        static let hidePromocodesButtonTitle = "Скрыть промокоды"
        static let alertErrorTitle = "Что-то пошло не так..."
        static let topAnchorMargin: CGFloat = 16
        static let leadingAnchorMargin: CGFloat = 16
        static let trailingAnchorMargin: CGFloat = -16
    }
    
    private lazy var orderScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bouncesVertically = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dividerTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColorProperties.dividerTopViewColor
        return view
    }()
    
    private lazy var promocodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var promocodeInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.promocodeInfoLabelText
        label.textAlignment = .left
        label.textColor = UIColorProperties.grayLabelColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var activePromocodesButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = Constants.activePromocodesButtonTitle
        config.image = Constants.activePromocodeButtonImage
        config.imagePadding = 10
        config.baseForegroundColor = UIColorProperties.promocodeButtonColorsProperties
        config.background.backgroundColor = UIColorProperties.activePromocodeButtonBackgroundColor
        config.cornerStyle = .medium
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        button.addTarget(self, action: #selector(addNewPromocodeHandler), for: .touchUpInside)
        return button
    }()

    
    private lazy var promocodesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        tableView.register(PromocodesTableViewCell.self, forCellReuseIdentifier: PromocodesTableViewCell.identifer)
        return tableView
    }()
    
    private lazy var hidePromocodesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.hidePromocodesButtonTitle, for: .normal)
        button.setTitleColor(UIColorProperties.promocodeButtonColorsProperties, for: .normal)
        button.addTarget(self, action: #selector(handleHidePromocodes), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomOrderView: BottomOrderScreenView = {
        let view = BottomOrderScreenView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var order: Order?
    private let viewModel: OrderViewModel
    
    init(frame: CGRect, viewModel: OrderViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentHeight = promocodesTableView.contentSize.height
        tableViewHeightConstraint?.constant = contentHeight
        contentView.layoutIfNeeded()
        orderScrollView.contentSize = contentView.frame.size
    }
    
    // MARK: - Public Methods
    func updateBottomViewUI(totalSum: Double, totalDiscount: Int) {
        bottomOrderView.updateBottomViewDataUI(totalSum, totalDiscount)
    }
    
    func showOrder(_ order: Order) {
        self.order = order
        promocodeLabel.text = order.screenTitle
        bottomOrderView.setData(order)
        promocodesTableView.reloadData()
    }
    
    func updateLayoutSubviews() {
        layoutSubviews()
    }
    
    func changeHideButtonTitle(on isActive: Bool) {
        if isActive {
            hidePromocodesButton.setTitle("Показать промокоды", for: .normal)
        } else {
            hidePromocodesButton.setTitle("Скрыть промокоды", for: .normal)
        }
    }
    
    func showErrorLabel(for ui: UIType) {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = Constants.alertErrorTitle
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.boldSystemFont(ofSize: 24)
        addSubview(errorLabel)
        
        switch ui {

        case .tableView:
            promocodesTableView.isHidden = true
            errorLabel.topAnchor.constraint(equalTo: activePromocodesButton.bottomAnchor, constant: 16).isActive = true
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            errorLabel.bottomAnchor.constraint(equalTo: hidePromocodesButton.topAnchor, constant: -16).isActive = true

        case .bottomView:
            bottomOrderView.isHidden = true
            errorLabel.topAnchor.constraint(equalTo: promocodesTableView.bottomAnchor, constant: 16).isActive = true
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true

        case .uiview:
            hideUI()
            errorLabel.topAnchor.constraint(equalTo: promocodeInfoLabel.bottomAnchor, constant: 16).isActive = true
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
            
        }
        
    }
    
    func updateTableViewCellSwitch(for indexPath: Int) {
        guard let cell = promocodesTableView.cellForRow(at: IndexPath(row: indexPath, section: 0)) as? PromocodesTableViewCell else {
            return
        }
        cell.turnOffSwitch()
    }
}

// MARK: - OrderScreenView + UITableViewDataSource
extension OrderScreenView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let order = order else {
            return 0
        }
        return order.promocodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PromocodesTableViewCell.identifer, for: indexPath) as? PromocodesTableViewCell,
        let order = order else {
            return UITableViewCell()
        }
        
        cell.setSwitchHandler { [weak self] isOn in
            self?.viewModel.handleSwitch(isOn, indexPath: indexPath.row)
        }
        
        cell.configureCell(order.promocodes[indexPath.row])
        
        return cell
    }
    
}

// MARK: - Private Methods
private extension OrderScreenView {
    
    func hideUI() {
        activePromocodesButton.isHidden = true
        promocodesTableView.isHidden = true
        hidePromocodesButton.isHidden = true
        bottomOrderView.isHidden = true
    }
    
    @objc
    func addNewPromocodeHandler() {
        viewModel.showNextController()
    }
    
    @objc
    func handleHidePromocodes() {
        viewModel.hidePromocodesAction()
    }
    
    func setupView() {
        addSubview(orderScrollView)

        orderScrollView.addSubview(contentView)

        contentView.addSubview(dividerTopView)
        contentView.addSubview(promocodeLabel)
        contentView.addSubview(promocodeInfoLabel)
        contentView.addSubview(activePromocodesButton)
        contentView.addSubview(promocodesTableView)
        contentView.addSubview(hidePromocodesButton)
        contentView.addSubview(bottomOrderView)

        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            orderScrollView.topAnchor.constraint(equalTo: topAnchor),
            orderScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            orderScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            orderScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: orderScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: orderScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: orderScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: orderScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: orderScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dividerTopView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dividerTopView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dividerTopView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dividerTopView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            promocodeLabel.topAnchor.constraint(equalTo: dividerTopView.bottomAnchor, constant: Constants.topAnchorMargin),
            promocodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            promocodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        tableViewHeightConstraint = promocodesTableView.heightAnchor.constraint(equalToConstant: 120)
        tableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            promocodeInfoLabel.topAnchor.constraint(equalTo: promocodeLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            promocodeInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            promocodeInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            activePromocodesButton.topAnchor.constraint(equalTo: promocodeInfoLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            activePromocodesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            activePromocodesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin),
            activePromocodesButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            promocodesTableView.topAnchor.constraint(equalTo: activePromocodesButton.bottomAnchor, constant: Constants.topAnchorMargin),
            promocodesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            promocodesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            hidePromocodesButton.topAnchor.constraint(equalTo: promocodesTableView.bottomAnchor, constant: 8),
            hidePromocodesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            hidePromocodesButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin),
            hidePromocodesButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            bottomOrderView.topAnchor.constraint(greaterThanOrEqualTo: hidePromocodesButton.bottomAnchor, constant: Constants.topAnchorMargin),
            bottomOrderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomOrderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomOrderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomOrderView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}

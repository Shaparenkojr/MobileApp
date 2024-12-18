//
//  PromocodesTableViewCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 18.10.2024.
//

import Foundation
import UIKit

final class PromocodesTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let promocodeInfoButtonImage = UIImage(named: "info_circle")
    }
    
    static let identifer = String(describing: PromocodesTableViewCell.self)
    
    private lazy var contentViewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColorProperties.grayBackgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var leftSideViewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var rightSideViewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var promocodeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var saleView: SaleView = {
        let view = SaleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColorProperties.saleViewColor
        return view
    }()
    
    private lazy var promocodeInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.promocodeInfoButtonImage, for: .normal)
        return button
    }()
    
    private lazy var promocodeDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColorProperties.grayLabelColor
        return label
    }()
    
    private lazy var promocodeActivationSwitch: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.isOn = false
        switcher.onTintColor = UIColorProperties.switcherONColor
        switcher.addTarget(self, action: #selector(switchActivation), for: .valueChanged)
        return switcher
    }()
    
    private lazy var promocodeInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColorProperties.grayLabelColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var stackViewContent: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topView, bottomView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var switchHandler : ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        promocodeDateLabel.text = nil
        promocodeInfoLabel.text = nil
        promocodeTitleLabel.text = nil
        promocodeActivationSwitch.isOn = false
        switchHandler = nil
        promocodeInfoButton.setImage(Constants.promocodeInfoButtonImage, for: .normal)
        saleView.backgroundColor = UIColorProperties.saleViewColor
    }

    
    func turnOffSwitch() {
        promocodeActivationSwitch.setOn(false, animated: true)
    }
    
    func setSwitchHandler(closure: ((Bool) -> Void)?) {
        switchHandler = closure
    }
    
    func hideCell() {
        contentView.isHidden = true
    }
    
    func configureCell(_ order: Order.Promocode) {
        promocodeTitleLabel.text = order.title
        saleView.configureLabel(text: order.percent)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        if let date = order.endDate {
            let formattedDate = formatter.string(from: date)
            promocodeDateLabel.text = "По \(formattedDate)"
        } else {
            promocodeDateLabel.isHidden = true
        }
        
        if let promocodeInfo = order.info {
            promocodeInfoLabel.text = promocodeInfo
        } else {
//            promocodeInfoLabel.isHidden = true
//            bottomView.isHidden = true
//            stackViewContent.arrangedSubviews[1].isHidden = true
        }
        promocodeActivationSwitch.isOn = order.active
    }
}

private extension PromocodesTableViewCell {
    
    @objc
    func switchActivation() {
        switchHandler?(promocodeActivationSwitch.isOn)
    }
    
    func setupCell() {
        contentView.addSubview(contentViewCell)
        contentViewCell.addSubview(leftSideViewCell)
        contentViewCell.addSubview(rightSideViewCell)
        
        contentViewCell.addSubview(stackViewContent)
        
        topView.addSubview(promocodeTitleLabel)
        topView.addSubview(saleView)
        topView.addSubview(promocodeInfoButton)
        topView.addSubview(promocodeActivationSwitch)
        topView.addSubview(promocodeDateLabel)
        
        bottomView.addSubview(promocodeInfoLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            leftSideViewCell.leadingAnchor.constraint(equalTo: contentViewCell.leadingAnchor, constant: -10),
            leftSideViewCell.centerYAnchor.constraint(equalTo: contentViewCell.centerYAnchor, constant: 0),
            leftSideViewCell.heightAnchor.constraint(equalToConstant: 20),
            leftSideViewCell.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            rightSideViewCell.trailingAnchor.constraint(equalTo: contentViewCell.trailingAnchor, constant: 10),
            rightSideViewCell.centerYAnchor.constraint(equalTo: contentViewCell.centerYAnchor, constant: 0),
            rightSideViewCell.heightAnchor.constraint(equalToConstant: 20),
            rightSideViewCell.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            contentViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            contentViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            contentViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            contentViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            stackViewContent.topAnchor.constraint(equalTo: contentViewCell.topAnchor),
            stackViewContent.leadingAnchor.constraint(equalTo: contentViewCell.leadingAnchor),
            stackViewContent.trailingAnchor.constraint(equalTo: contentViewCell.trailingAnchor),
            stackViewContent.bottomAnchor.constraint(equalTo: contentViewCell.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            promocodeTitleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 26),
            promocodeTitleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            saleView.heightAnchor.constraint(equalToConstant: 20),
            saleView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            saleView.centerYAnchor.constraint(equalTo: promocodeTitleLabel.centerYAnchor, constant: 0),
            saleView.leadingAnchor.constraint(equalTo: promocodeTitleLabel.trailingAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            promocodeInfoButton.widthAnchor.constraint(equalToConstant: 20),
            promocodeInfoButton.heightAnchor.constraint(equalToConstant: 20),
            promocodeInfoButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            promocodeInfoButton.leadingAnchor.constraint(equalTo: saleView.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            promocodeActivationSwitch.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -26),
            promocodeActivationSwitch.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0)
        ])
        
        
        NSLayoutConstraint.activate([
            promocodeDateLabel.topAnchor.constraint(equalTo: promocodeTitleLabel.bottomAnchor, constant: 4),
            promocodeDateLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 26),
            promocodeDateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -4),
            promocodeDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: topView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            promocodeInfoLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 26),
            promocodeInfoLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 2),
            promocodeInfoLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -8),
            promocodeInfoLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -8),
        ])
    }

}

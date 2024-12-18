//
//  ConfirmReviewCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 01.11.2024.
//

import UIKit

final class ConfirmReviewCell: UITableViewCell {
    
    static let identifier: String = String(describing: ConfirmReviewCell.self)
    
    private enum Constants {
        static let buttonColor: UIColor = UIColor(red: 255.0 / 255.0, green: 70.0 / 255.0, blue: 17.0 / 255.0 , alpha: 1)
    }
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.buttonColor
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmRulesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString()
        let firstPart = NSAttributedString(string: "Перед отправкой отзыва, пожалуйста,\n ознакомьтесь с",
                                           attributes: [
                                            .font: UIFont.systemFont(ofSize: 12),
                                            .foregroundColor: UIColor.lightGray
                                           ])
        
        let secondPart = NSAttributedString(string: " правилами публикации", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.orange
        ])
        
        attributedString.append(firstPart)
        attributedString.append(secondPart)
        
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private var isTapped: Bool = false
    
    var viewModel: ReviewProductViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(with buttonTitle: String) {
        confirmButton.setTitle(buttonTitle, for: .normal)
    }
}

private extension ConfirmReviewCell {
    
    @objc
    func confirmButtonTapped() {
        viewModel?.toggleErrorCell(index: 2)
    }
    
    func setupCell() {
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(confirmButton)
        contentCellView.addSubview(confirmRulesLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.heightAnchor.constraint(equalToConstant: 54),
            confirmButton.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 4),
            confirmButton.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 8),
            confirmButton.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            confirmRulesLabel.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 16),
            confirmRulesLabel.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
            confirmRulesLabel.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -16),
            confirmRulesLabel.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16)
        ])
    }
}

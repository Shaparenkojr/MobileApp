//
//  CheckBoxCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 01.11.2024.
//

import UIKit

final class CheckBoxCell: UITableViewCell {
    
    static let identifier: String = String(describing: CheckBoxCell.self)
    
    private enum Constants {
        static let offCheckBoxImage = UIImage(named: "offCheckbox")
        static let onCheckBoxImage = UIImage(named: "onCheckbox")
    }
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var checkBox: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = Constants.offCheckBoxImage
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped))
        imageView.addGestureRecognizer(gestureRecognizer)
        return imageView
    }()
    
    private lazy var checkBoxTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private var isOnCheckBox: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with title: String) {
        checkBoxTitleLabel.text = title
    }
}

private extension CheckBoxCell {
    
    @objc
    func checkBoxTapped() {
        if isOnCheckBox {
            checkBox.image = Constants.offCheckBoxImage
            isOnCheckBox.toggle()
        } else {
            checkBox.image = Constants.onCheckBoxImage
            isOnCheckBox.toggle()
        }
    }
    
    func setupCell() {
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(checkBox)
        contentCellView.addSubview(checkBoxTitleLabel)
        
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
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            checkBox.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
            checkBox.centerYAnchor.constraint(equalTo: contentCellView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkBoxTitleLabel.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 8),
            checkBoxTitleLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 16),
            checkBoxTitleLabel.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -16),
            checkBoxTitleLabel.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -8),
        ])
    }
}

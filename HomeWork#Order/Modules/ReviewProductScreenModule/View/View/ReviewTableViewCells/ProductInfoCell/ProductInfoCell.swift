//
//  ProductInfoCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 31.10.2024.
//

import UIKit

final class ProductInfoCell: UITableViewCell {
    
    static let identifier: String = String(describing: ProductInfoCell.self)
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var productSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(imageName: String, productName: String, productSize: Int) {
        productImageView.image = UIImage(named: imageName)
        productNameLabel.text = productName
        productSizeLabel.text = "Размер: \(productSize)"
    }
}

private extension ProductInfoCell {
    
    func setupCell() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productSizeLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productNameLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            productSizeLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 4),
            productSizeLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            productSizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productSizeLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

//
//  ProductRatingCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 01.11.2024.
//

import UIKit

final class ProductRatingCell: UITableViewCell {
    
    static let identifier: String = String(describing: ProductRatingCell.self)
    
    private enum Constants {
        static let productRatingLabelText = "Ваша оценка"
        static let starNotFilledImage = UIImage(named: "notFillStar")
        static let starFilledImage = UIImage(named: "fillStar")
        static let productRatingVeryBadText = "Ужасно"
        static let productRatingBadText = "Плохо"
        static let productRatingOkTExt = "Нормально"
        static let productRatingGoodText = "Хорошо"
        static let productRatingWellText = "Отлично"
    }
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BackgroundColorsCells.tableViewCellCustomDefaultColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var productRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.text = Constants.productRatingLabelText
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var ratingStarsImageViewsArray: [UIImageView] = []
    
    var userRating: Int = 0 {
        didSet {
            onRatingChange?(userRating)
        }
    }
        
    var onRatingChange: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setRatingImages()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ProductRatingCell {
    
    func setupCell() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(productRatingLabel)
        contentCellView.addSubview(ratingStackView)
        
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
            productRatingLabel.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
            productRatingLabel.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
            productRatingLabel.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            ratingStackView.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
            ratingStackView.leadingAnchor.constraint(greaterThanOrEqualTo: productRatingLabel.trailingAnchor, constant: 16),
            ratingStackView.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -24),
            ratingStackView.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16)
        ])
    }
    
    func setRatingImages() {
        for index in 0..<5 {
            let imageView = UIImageView()
            imageView.image = Constants.starNotFilledImage
            imageView.isUserInteractionEnabled = true
            imageView.tag = index
            let gesture = UITapGestureRecognizer(target: self, action: #selector(starTapped(_:)))
            imageView.addGestureRecognizer(gesture)
            ratingStarsImageViewsArray.append(imageView)
            ratingStackView.addArrangedSubview(imageView)
        }
    }
    
    func updateStars(rating: Int) {
        for (index, imageView) in ratingStarsImageViewsArray.enumerated() {
            if index <= rating {
                imageView.image = Constants.starFilledImage
            } else {
                imageView.image = Constants.starNotFilledImage
            }
        }
    }
    
    func updateRatingLabel() {
        switch userRating {
        case 1:
            productRatingLabel.text = Constants.productRatingVeryBadText
        case 2:
            productRatingLabel.text = Constants.productRatingBadText
        case 3:
            productRatingLabel.text = Constants.productRatingOkTExt
        case 4:
            productRatingLabel.text = Constants.productRatingGoodText
        case 5:
            productRatingLabel.text = Constants.productRatingWellText
        default:
            productRatingLabel.text = Constants.productRatingLabelText
        }
    }
    
    @objc
    func starTapped(_ sender: UITapGestureRecognizer) {
        if let imageTapped = sender.view as? UIImageView {
            updateStars(rating: imageTapped.tag)
            userRating = imageTapped.tag + 1
            updateRatingLabel()
        }
    }
}

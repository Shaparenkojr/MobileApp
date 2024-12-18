//
//  UploadedPhotoCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 01.11.2024.
//

import UIKit

final class UploadedPhotoCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: UploadedPhotoCell.self)
    
    private enum Constants {
        static let deleteImage = UIImage(named: "deleteImage")
    }
    
    private lazy var reviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deletePhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.deleteImage, for: .normal)
        button.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        return button
    }()
    
    private var photoIndex: Int?
    var viewModel: ReviewProductViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with imageName: String, at index: Int) {
        reviewImageView.image = UIImage(named: imageName)
        self.photoIndex = index
    }
}

private extension UploadedPhotoCell {
    
    @objc
    func deletePhoto() {
        guard let index = photoIndex else { return }
        viewModel?.onPhotoDelete?(index)
    }
    
    func setupCell() {
        contentView.addSubview(reviewImageView)
        contentView.addSubview(deletePhotoButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            reviewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            reviewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reviewImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deletePhotoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            deletePhotoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            deletePhotoButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16)
        ])
    }
}

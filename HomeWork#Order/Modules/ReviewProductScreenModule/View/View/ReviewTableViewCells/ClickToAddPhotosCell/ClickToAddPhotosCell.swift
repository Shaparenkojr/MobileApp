//
//  ClickToAddPhotosCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 03.11.2024.
//

import UIKit

final class ClickToAddPhotosCell: UITableViewCell {
    
    static let identifier: String = String(describing: ClickToAddPhotosCell.self)
    
    private enum Constants {
        static let uploadImage = UIImage(named: "uploadImage")
        static let addPhotoVideoLabelText = "Добавьте фото или видео"
        static let clickHereLabelText = "Нажмите, чтобы выбрать файлы"
    }
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BackgroundColorsCells.tableViewCellCustomDefaultColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.uploadImage
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var addPhotoVideoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.addPhotoVideoLabelText
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var clickHereLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.clickHereLabelText
        label.font = .systemFont(ofSize: 12)
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
}

private extension ClickToAddPhotosCell {
    
    func setupCell() {
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(uploadImageView)
        contentCellView.addSubview(addPhotoVideoLabel)
        contentCellView.addSubview(clickHereLabel)
        
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
            uploadImageView.widthAnchor.constraint(equalToConstant: 24),
            uploadImageView.heightAnchor.constraint(equalToConstant: 24),
            uploadImageView.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
            uploadImageView.centerYAnchor.constraint(equalTo: contentCellView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoVideoLabel.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
            addPhotoVideoLabel.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 16),
            addPhotoVideoLabel.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -16),
            addPhotoVideoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            clickHereLabel.topAnchor.constraint(equalTo: addPhotoVideoLabel.bottomAnchor, constant: 5),
            clickHereLabel.leadingAnchor.constraint(equalTo: addPhotoVideoLabel.leadingAnchor),
            clickHereLabel.trailingAnchor.constraint(equalTo: addPhotoVideoLabel.trailingAnchor),
            clickHereLabel.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16)
        ])
        
        clickHereLabel.heightAnchor.constraint(equalTo: addPhotoVideoLabel.heightAnchor).isActive = true
    }
}

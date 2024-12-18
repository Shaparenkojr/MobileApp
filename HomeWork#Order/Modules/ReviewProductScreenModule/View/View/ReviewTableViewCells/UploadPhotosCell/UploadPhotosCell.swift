//
//  UploadPhotosCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 01.11.2024.
//

import UIKit

final class UploadPhotosCell: UITableViewCell {
    
    static let identifier: String = String(describing: UploadPhotosCell.self)
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = BackgroundColorsCells.tableViewCellCustomDefaultColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var uploadedPhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: frame.width / 4 - 5, height: 80)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.register(UploadedPhotoCell.self, forCellWithReuseIdentifier: UploadedPhotoCell.identifier)
        collectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: AddPhotoCell.identifier)
        return collectionView
    }()
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    private var photos: [String] {
        return viewModel?.uploadedNamesPhotos ?? []
    }
    
    var viewModel: ReviewProductViewModel? {
        didSet {
            viewModel?.onPhotosUpdate = { [weak self] in
                self?.uploadedPhotosCollectionView.reloadData()
                self?.updateCollectionViewHeight()
                if let tableView = self?.superview as? UITableView {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCollectionViewHeight() {
        uploadedPhotosCollectionView.layoutIfNeeded()
        let height = uploadedPhotosCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeightConstraint?.constant = height
    }

}

extension UploadPhotosCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.count == 7 {
            return photos.count
        } else {
            return photos.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == photos.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.identifier, for: indexPath) as? AddPhotoCell else {
                return UICollectionViewCell()
            }
            
            cell.viewModel = viewModel
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadedPhotoCell.identifier, for: indexPath) as? UploadedPhotoCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = viewModel
            cell.configureCell(with: photos[indexPath.item], at: indexPath.item)
            return cell
        }
    }
}

private extension UploadPhotosCell {
    
    func setupCell() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(uploadedPhotosCollectionView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        collectionViewHeightConstraint = uploadedPhotosCollectionView.heightAnchor.constraint(equalToConstant: 80)
        collectionViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            uploadedPhotosCollectionView.topAnchor.constraint(equalTo: contentCellView.topAnchor),
            uploadedPhotosCollectionView.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor),
            uploadedPhotosCollectionView.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor),
            uploadedPhotosCollectionView.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor)
        ])
        
    }
}

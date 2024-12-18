

import UIKit

final class ReviewProductView: UIView {
    
    private lazy var reviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(ProductInfoCell.self,
                           forCellReuseIdentifier: ProductInfoCell.identifier)
        tableView.register(ProductRatingCell.self,
                           forCellReuseIdentifier: ProductRatingCell.identifier)
        tableView.register(UploadPhotosCell.self,
                           forCellReuseIdentifier: UploadPhotosCell.identifier)
        tableView.register(UserReviewCell.self,
                           forCellReuseIdentifier: UserReviewCell.identifier)
        tableView.register(CheckBoxCell.self,
                           forCellReuseIdentifier: CheckBoxCell.identifier)
        tableView.register(ConfirmReviewCell.self,
                           forCellReuseIdentifier: ConfirmReviewCell.identifier)
        tableView.register(ClickToAddPhotosCell.self,
                           forCellReuseIdentifier: ClickToAddPhotosCell.identifier)
        tableView.register(ErrorCell.self,
                           forCellReuseIdentifier: ErrorCell.identifier)
        
        return tableView
    }()
    
    private let viewModel: ReviewProductViewModel
    var activeIndexPath: IndexPath?
    
    init(frame: CGRect, viewModel: ReviewProductViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setupKeyboardObservers()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReviewProductView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.tableViewCells[indexPath.row]
        
        switch cellType {
        case .productInfo(let imageName, let productName, let productSize):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoCell.identifier, for: indexPath) as? ProductInfoCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.configureCell(imageName: imageName, productName: productName, productSize: productSize)
            return cell

        case .productRating:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductRatingCell.identifier, for: indexPath) as? ProductRatingCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.onRatingChange = { [weak self] rating in
                self?.viewModel.updateRating(rating)
            }
            return cell

        case .clickToAddPhoto:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ClickToAddPhotosCell.identifier, for: indexPath) as? ClickToAddPhotosCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            
            return cell

        case .productUserReview(let textFieldPlaceHolder):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserReviewCell.identifier, for: indexPath) as? UserReviewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.viewModel = viewModel
            cell.configureCell(placeholderText: textFieldPlaceHolder)
            return cell

        case .checkBox(let title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxCell.identifier, for: indexPath) as? CheckBoxCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.configureCell(with: title)
            return cell

        case .submitButton(let buttonTitle):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConfirmReviewCell.identifier, for: indexPath) as? ConfirmReviewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.viewModel = viewModel
            cell.configureUI(with: buttonTitle)
            return cell

        case .uploadPhotos:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UploadPhotosCell.identifier, for: indexPath) as? UploadPhotosCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.viewModel = viewModel
            
            return cell

        case .errorCell:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorCell.identifier, for: indexPath) as? ErrorCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
}

extension ReviewProductView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = viewModel.tableViewCells[indexPath.row]
        if cellType == .clickToAddPhoto {
            viewModel.changeCellInTableView?(indexPath.row)
        }
    }
}

extension ReviewProductView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view, view is UITextField {
            return false
        }
        return true
    }
}

private extension ReviewProductView {
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeIndexPath = activeIndexPath else { return }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        reviewTableView.contentInset = contentInsets
        reviewTableView.scrollIndicatorInsets = contentInsets
        
        DispatchQueue.main.async {
            self.reviewTableView.scrollToRow(at: activeIndexPath, at: .middle, animated: true)
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        reviewTableView.contentInset = .zero
        reviewTableView.scrollIndicatorInsets = .zero
    }
    
    func setupView() {
        addSubview(reviewTableView)
        
        setupConstraints()
        setupBindings()
        setupGesture()
    }
    
    func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        reviewTableView.addGestureRecognizer(gesture)
    }
    
    @objc
    func hideKeyboard() {
        endEditing(true)
    }
    
    func setupBindings() {
        viewModel.onUploadPhoto = { [weak self] in
            guard let self = self else { return }
            self.viewModel.uploadNewPhoto()
        }
        
        viewModel.onPhotoDelete = { [weak self] index in
            guard let self = self else { return }
            self.viewModel.deletePhoto(indexImage: index)
        }
        
        viewModel.changeCellInTableView = { [weak self] index in
            guard let self = self else { return }
            self.viewModel.changeCell(index: index)
            self.reviewTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        viewModel.onConfirmButtomTap = { [weak self] index in
            guard let self = self else { return }
            
            self.reviewTableView.beginUpdates()
            if self.viewModel.hasErrorCell {
                self.reviewTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
            self.reviewTableView.endUpdates()
        }

        viewModel.onRatingChanged = { [weak self] index in
            guard let self = self else { return }
            
            self.reviewTableView.beginUpdates()
            if !self.viewModel.hasErrorCell {
                self.reviewTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
            self.reviewTableView.endUpdates()
        }
        
        viewModel.moveToNextField = { [weak self] nextIndexPath in
            guard let self = self else { return }
            if let nextCell = self.reviewTableView.cellForRow(at: nextIndexPath) as? UserReviewCell {
                nextCell.activateTextField()
            }
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            reviewTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            reviewTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            reviewTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            reviewTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

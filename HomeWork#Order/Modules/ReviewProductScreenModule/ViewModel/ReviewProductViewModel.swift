
import Foundation

final class ReviewProductViewModel {
    
    private let imageNames = ["ruka1", "ruka2", "ruka3", "ruka4", "ruka5", "ruka6", "ruka7"]
    private var currentImageIndex = 0
    private var currentRating: Int = 0
    private var productData: Product
    
    var hasErrorCell = false
    var tableViewCells: [ReviewCellsType] = []
    var uploadedNamesPhotos: [String] = []
    
    var onUploadPhoto: (() -> Void)?
    var onPhotoDelete: ((Int) -> Void)?
    var onConfirmButtomTap: ((Int) -> Void)?
    var onRatingChanged: ((Int) -> Void)?
    var onPhotosUpdate: (() -> Void)?
    var moveToNextField: ((IndexPath) -> Void)?
    var changeCellInTableView: ((Int) -> Void)?
        
    init(productData: Product) {
        self.productData = productData
        setupTableViewCellsType()
    }
    
    func changeCell(index: Int) {
        print(index)
        tableViewCells[index] = ReviewCellsType.uploadPhotos
    }
    
    func requestMoveToNextField(from indexPath: IndexPath) {
        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        moveToNextField?(nextIndexPath)
    }
    
    func uploadNewPhoto() {
        let imageName = imageNames[currentImageIndex]
        uploadedNamesPhotos.append(imageName)
        
        currentImageIndex = (currentImageIndex + 1) % imageNames.count
        
        onPhotosUpdate?()
    }
    
    func deletePhoto(indexImage: Int) {
        guard indexImage < uploadedNamesPhotos.count else { return }
        uploadedNamesPhotos.remove(at: indexImage)
        onPhotosUpdate?()
    }
    
    func toggleErrorCell(index: Int) {
        if currentRating == 0 && !hasErrorCell {
            tableViewCells.insert(.errorCell, at: index)
            hasErrorCell = true
            onConfirmButtomTap?(index)
        } else if currentRating > 0 && hasErrorCell {
            tableViewCells.removeAll { $0 == .errorCell }
            hasErrorCell = false
            onRatingChanged?(index)
        }
    }
    
    func updateRating(_ rating: Int) {
        currentRating = rating
        toggleErrorCell(index: 2)
    }
}

private extension ReviewProductViewModel {
    
    func setupTableViewCellsType() {
        tableViewCells = [
            .productInfo(imageName: productData.imageName,
                         productName: productData.productName,
                         productSize: productData.productSize),
            .productRating,
            .clickToAddPhoto,
            .productUserReview(textFieldPlaceholder: "Достоинства"),
            .productUserReview(textFieldPlaceholder: "Недостатки"),
            .productUserReview(textFieldPlaceholder: "Комментарий"),
            .checkBox(title: "Оставить отзыв анонимно"),
            .submitButton(buttonTitle: "Отправить")
            ]
    }
}

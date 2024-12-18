

import Foundation

enum ReviewCellsType: Equatable {
    case productInfo(imageName: String, productName: String, productSize: Int)
    case productRating
    case clickToAddPhoto
    case productUserReview(textFieldPlaceholder: String)
    case checkBox(title: String)
    case submitButton(buttonTitle: String)
    case uploadPhotos
    case errorCell
}

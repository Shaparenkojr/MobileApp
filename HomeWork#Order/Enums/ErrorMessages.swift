

import Foundation

enum ErrorMessages {
    static let titleAlert = "Что-то пошло не так..."
    static let moreThanTwoCurrentActivatedPromocodes = "Вы не можете активировать более 2-х промокодов одновременно"
    static let emptyProducts = "На данный момент, заказов в корзине нет"
    static let invalidCountActivatedPromocodes = "Было активировано более 2-х промокодов"
    static let invalidProductsCost = "Цена заказов должна быть больше нуля"
    static let invalidBaseDiscount = "Стартовая скидка не может быть больше чем цена"
    static let cantGetData = "Не удалось получить данные"
    static let cantGetProductsData = "Не получилось получить данные о товарах"
}

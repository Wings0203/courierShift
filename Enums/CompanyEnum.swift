//
//  CompanyEnum.swift
//  courierShift
//
//  Created by Татьяна Федотова on 10.05.2025.
//

enum CompanyEnum: Int {
    case yandexFood = 50 //52
    case samokat = 1 //54
    case deliveryClub = 2 //55
    case cooper = 3//56
    
    var title: String {
        switch self {
        case .yandexFood:
            return "Яндекс Еда"
        case .samokat:
            return "Самокат"
        case .deliveryClub:
            return "Delivery Club"
        case .cooper:
            return "Купер"
        }
    }
    
    static func title(for rawValue: Int) -> String {
        return CompanyEnum(rawValue: rawValue)?.title ?? "Неизвестная компания"
    }
}

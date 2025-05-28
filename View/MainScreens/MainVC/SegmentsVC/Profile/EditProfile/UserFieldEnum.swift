//
//  UserFieldEnum.swift
//  courierShift
//
//  Created by Татьяна Федотова on 17.05.2025.
//

enum UserFieldEnum: CaseIterable {
    case firstName
    case surname
    case middleName
    case phone
    case email
    
    var title: String {
        switch self {
        case .firstName: return "Имя"
        case .surname: return "Фамилия"
        case .middleName: return "Отчество"
        case .phone: return "Телефон"
        case .email: return "Email"
        }
    }
    
    var placeHolder: String {
        return "Введите \(title.lowercased())"
    }

}

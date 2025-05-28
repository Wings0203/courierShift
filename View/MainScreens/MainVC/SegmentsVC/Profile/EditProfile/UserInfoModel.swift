//
//  UserInfoModel.swift
//  courierShift
//
//  Created by Татьяна Федотова on 17.05.2025.
//


у меня есть такая модель
struct UserInfoModel: Codable {
    let firstName: String
    let surname: String
    let middleName: String
    let phone: String
    let email: String
}

когда я перехожу на экран я должен ввести значения как textField.text. я должен иметь соответствие между textField.text и полем модели

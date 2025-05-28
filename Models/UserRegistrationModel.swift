//
//  UserRegistrationModel.swift
//  courierShift
//
//  Created by Татьяна Федотова on 19.01.2025.
//

import Foundation

struct UserRegistrationModel: Codable {
    let lastName: String
    let firstName: String
    let fatherName: String
    let phoneNumer: String
    let email: String
    let password: String
    let confirmPassword: String
}

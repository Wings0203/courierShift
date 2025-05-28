//
//  SignUpModel.swift
//  courierShift
//
//  Created by Татьяна Федотова on 28.02.2025.
//

import Foundation

struct SignUpModel: Codable {
    let email: String
    let password: String
    let firstName: String
    let surname: String
    let middleName: String
    let phoneNumber: String
}

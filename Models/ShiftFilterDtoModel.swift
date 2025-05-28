//
//  ShiftFilterDtoModel.swift
//  courierShift
//
//  Created by Татьяна Федотова on 18.05.2025.
//

struct ShiftFilterDtoModel: Codable {
    let companyId: Int
    let startAfter: String
    let endBefore: String
}

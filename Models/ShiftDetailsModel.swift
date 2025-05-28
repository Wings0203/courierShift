//
//  ShiftDetailsModel.swift
//  courierShift
//
//  Created by Татьяна Федотова on 10.05.2025.
//

struct ShiftDetailsModel: Codable {
    let id: Int
    let companyId: Int
    let startTime: String
    let endTime: String
    let location: String
    let locationLatitude: Int
    let locationLongitude: Int
    let minRate: Int
    let avgRate: Int
    let status: String
    let requiredDeliveryType: String
    var companyName: String?
}

//
//  ShiftInfoModel.swift
//  courierShift
//
//  Created by Татьяна Федотова on 14.05.2025.
//

struct ShiftInfoModel: Codable {
    let id: Int
    let companyId: Int
    let startTime: String
    let endTime: String
    let location: String
    let locationLatitude: Int
    let locationLongitude: Int
    let minRate: Int
    let avgRate: Int
    let status: ShiftStatus
    let requiredDeliveryType: ShiftDeliveryType
}

enum ShiftStatus: String, Codable {
    case open = "OPEN"
    case booked = "BOOKED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}

enum ShiftDeliveryType: String, Codable {
    case bike = "BIKE"
    case car = "CAR"
    case scooter = "SCOOTER"
    case foot = "FOOT"
}

//
//  ShiftCellModel.swift
//  courierShift
//
//  Created by Татьяна Федотова on 10.05.2025.
//

struct ShiftCellModel: Codable {
    let shiftId: Int
    let companyId: Int
    let time: String
    let date: String
    var companyName: String?
}

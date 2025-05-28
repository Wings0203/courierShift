//
//  DropdownMenuDelegate.swift
//  courierShift
//
//  Created by Татьяна Федотова on 20.05.2025.
//

protocol DropdownMenuDelegate: AnyObject {
    func applyShiftsFilter(dtoModel: ShiftFilterDtoModel)
    func toggleDropdown(isOpen: Bool)
}

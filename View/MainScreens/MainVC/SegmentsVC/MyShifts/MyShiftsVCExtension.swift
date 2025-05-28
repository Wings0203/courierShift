//
//  MyShiftsVCExtension.swift
//  courierShift
//
//  Created by Татьяна Федотова on 15.05.2025.
//

import UIKit

extension MyShiftsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shiftCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedShiftCell", for: indexPath) as! ShiftCell
        let shiftModel = shiftCellData[indexPath.row]
        cell.setUpCellData(cellModel: shiftModel)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = shiftCellData[indexPath.row]
        
        navigationController?.pushViewController(ShiftDetailsViewController(model: model, screenType: .myShifts), animated: true)
    }
}

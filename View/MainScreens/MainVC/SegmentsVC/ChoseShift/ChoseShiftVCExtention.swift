//
//  ChoseShiftVCExtention.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

import UIKit

extension ChoseShiftVC: UITableViewDataSource, UITableViewDelegate, DropdownMenuDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shiftCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shiftCell", for: indexPath) as! ShiftCell
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
        
        navigationController?.pushViewController(ShiftDetailsViewController(model: model, screenType: .selectShift), animated: true)
    }
    
    //MARK: DropdownMenuDelegate
    
    func applyShiftsFilter(dtoModel: ShiftFilterDtoModel) {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        ShiftService().getFilteredShifts(token: accessToken, filterModel: dtoModel) { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let shifts):
                    let shiftCells = self.fetchShifts(shifts: shifts)
                    if shiftCells.isEmpty {
                        self.showToast(message: "Нет подходящих смен", color: .red)
                    }
                    self.shiftCellData = shiftCells
                    self.tableView.reloadData()
                    self.build.emptyTableViewLabel.removeFromSuperview()
                    self.setupNoDataCase()
                    print(shifts)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func toggleDropdown(isOpen: Bool) {
        build.emptyTableViewLabel.isHidden = isOpen
    }
}

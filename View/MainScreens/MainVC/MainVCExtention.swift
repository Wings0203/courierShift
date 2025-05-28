//
//  MyShiftsScreenVCExtention.swift
//  courierShift
//
//  Created by Татьяна Федотова on 09.05.2025.
//

//import UIKit
//
//extension MainViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        shiftCellData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "shiftCell", for: indexPath) as! ShiftCell
//        let shiftModel = shiftCellData[indexPath.row]
//        cell.setUpCellData(cellModel: shiftModel)
//
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        120
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let model = shiftCellData[indexPath.row]
//        
//        navigationController?.pushViewController(ShiftDetailsViewController(model: model), animated: true)
//    }
//}

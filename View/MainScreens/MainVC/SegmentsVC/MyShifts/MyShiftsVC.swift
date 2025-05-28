//
//  MyShiftsVC.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

import UIKit

class MyShiftsVC: UIViewController {
    
    private let build = MyShiftsView.shared
    var shiftCellData = [ShiftCellModel]()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSelectedShift()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        build.emptyTableViewLabel.removeFromSuperview()
    }
    
    private func setupTableView() {
        tableView = build.tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ShiftCell.self, forCellReuseIdentifier: "selectedShiftCell")
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNoDataCase() {
        if shiftCellData.isEmpty {
            let emptyTableViewLabel = build.emptyTableViewLabel
            view.addSubview(emptyTableViewLabel)
            
            NSLayoutConstraint.activate([
                emptyTableViewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyTableViewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
    
    private func getSelectedShift() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        ShiftService().getSelectedShifts(token: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let shifts):
                    self.fetchCompanies(token: accessToken) { companies in
                        let shiftCells = shifts.map { shift -> ShiftCellModel in
                            let companyName = companies.first { $0.id == shift.companyId }!.name
                            return self.convertShiftDetailsToShiftCell(shiftDetails: shift, companyName: companyName)
                        }
                        self.shiftCellData = shiftCells
                        self.tableView.reloadData()
                        self.setupNoDataCase()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func fetchCompanies(token: String, completion: @escaping ([CompanyModel]) -> Void) {
        CompanyService().getAllCompanies(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let companies):
                    completion(companies)
                case .failure(let error):
                    print(error)
                    completion([])
                }
            }
        }
    }
    
    private func convertShiftDetailsToShiftCell(shiftDetails: ShiftDetailsModel, companyName: String) -> ShiftCellModel {
        let date = extractDate(from: shiftDetails.startTime)
        let startTime = extractTime(from: shiftDetails.startTime)
        let endTime = extractTime(from: shiftDetails.endTime)
        
        let shiftCellModel = ShiftCellModel(shiftId: shiftDetails.id,
                                            companyId: shiftDetails.companyId,
                                            time: "\(startTime) - \(endTime)",
                                            date: date,
                                            companyName: companyName)
                                            
        return shiftCellModel
    }
    
    private func extractDate(from isoDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: isoDate) else { return "" }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        outputFormatter.locale = Locale(identifier: "ru_RU")

        return outputFormatter.string(from: date)
    }
    
    private func extractTime(from isoDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: isoDate) else { return "" }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        outputFormatter.locale = Locale(identifier: "ru_RU")

        return outputFormatter.string(from: date)
    }
    
}

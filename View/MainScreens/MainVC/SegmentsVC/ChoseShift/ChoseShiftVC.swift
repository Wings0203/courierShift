//
//  ChoseShiftVC.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

import UIKit

class ChoseShiftVC: UIViewController {
    
    let build = ChoseShiftView.shared
    var tableView = UITableView()
    var shiftCellData = [ShiftCellModel]()
    var companies = [CompanyModel]() {
        didSet {
            dropdownMenu.configureCompanies(companies)
        }
    }
    
    //Filters
    var dropdownMenu = DropdownMenu()
    private var dropdownHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropdownMenu()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCompanies()
        getAvailableShifts()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        build.emptyTableViewLabel.removeFromSuperview()
    }
    
    func setupNoDataCase() {
        if shiftCellData.isEmpty {
            let emptyTableViewLabel = build.emptyTableViewLabel
            view.addSubview(emptyTableViewLabel)
            
            NSLayoutConstraint.activate([
                emptyTableViewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyTableViewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
    
    private func setUpDropdownMenu() {
        dropdownMenu.delegate = self
        view.addSubview(dropdownMenu)

        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        
        dropdownHeightConstraint = dropdownMenu.heightAnchor.constraint(equalToConstant: dropdownMenu.currentHeight)

        NSLayoutConstraint.activate([
            dropdownMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dropdownMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            dropdownMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            dropdownHeightConstraint
        ])
        
        // Реакция на изменение высоты
        dropdownMenu.onHeightChange = { [weak self] newHeight in
            self?.dropdownHeightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func setUpTableView() {
        tableView = build.tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ShiftCell.self, forCellReuseIdentifier: "shiftCell")
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: dropdownMenu.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getAvailableShifts() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        ShiftService().getAvaliableShifts(token: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let shifts):
                    let shiftCells = self.fetchShifts(shifts: shifts)
                    self.shiftCellData = shiftCells
                    self.tableView.reloadData()
                    self.build.emptyTableViewLabel.removeFromSuperview()
                    self.setupNoDataCase()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchShifts(shifts: [ShiftDetailsModel]) -> [ShiftCellModel] {
        let shiftCells = shifts.map { shift -> ShiftCellModel in
            let companyName = self.companies.first { $0.id == shift.companyId }!.name
            return self.convertShiftDetailsToShiftCell(shiftDetails: shift, companyName: companyName)
        }
        return shiftCells
    }
    
    private func fetchCompanies() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        CompanyService().getAllCompanies(token: accessToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let companies):
                    self.companies = companies
                case .failure(let error):
                    print(error)
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
    
    func showToast(message: String, color: UIColor, duration: Double = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 14)
        toastLabel.backgroundColor = color.withAlphaComponent(0.8)
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0
        toastLabel.layer.cornerRadius = 12
        toastLabel.clipsToBounds = true

        let textSize = toastLabel.intrinsicContentSize
        let padding: CGFloat = 12
        let labelWidth = min(view.frame.width - 2 * padding, textSize.width + 2 * padding)
        let labelHeight = textSize.height + 2 * padding
        toastLabel.frame = CGRect(
            x: (view.frame.width - labelWidth) / 2,
            y: view.frame.height - labelHeight - 60,
            width: labelWidth,
            height: labelHeight
        )

        view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
}

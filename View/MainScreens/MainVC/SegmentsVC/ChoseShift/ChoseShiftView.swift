//
//  ChoseShiftView.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

import UIKit

class ChoseShiftView {
    
    static let shared = ChoseShiftView()
    private init() {}
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var emptyTableViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Sen-Regular", size: 18)
        label.text = "Нет доступных смен"
        label.numberOfLines = 0
        
        return label
    }()
}

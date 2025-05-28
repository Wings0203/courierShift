//
//  MyShiftsView.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

import UIKit

class MyShiftsView {
    
    static let shared = MyShiftsView()
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
        label.text = "У вас нет выбранных смен"
        label.numberOfLines = 0
        
        return label
    }()
}

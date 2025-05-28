//
//  MyShiftsScreenView.swift
//  courierShift
//
//  Created by Татьяна Федотова on 09.05.2025.
//

import UIKit

class MainView {
    
    static let shared = MainView()
    private init() {}
    
    lazy var logoutButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Logout", for: .normal)
        btn.backgroundColor = .darkGray
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var segmentControl: CustomSegmentControl = {
        let segControl = CustomSegmentControl()
        segControl.commaSeparatedButtonTitles = "1,2,3"
        segControl.translatesAutoresizingMaskIntoConstraints = false
        segControl.style = .dark
        return segControl
    }()
}

//
//  ShiftDetailsView.swift
//  courierShift
//
//  Created by Татьяна Федотова on 10.05.2025.
//

import UIKit

class ShiftDetailsView {
    
    static let shared = ShiftDetailsView()
    private init() {}
    
    let shiftName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Bold", size: 20)
        
        return lbl
    }()
    
    let shiftLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 16)
        
        return lbl
    }()
    
    let companyLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Компания:"
        lbl.font = UIFont(name: "Poppins-Bold", size: 18)
        
        return lbl
    }()
    
    let companyName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 18)
        
        return lbl
    }()
    
    let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Место доставки:"
        lbl.font = UIFont(name: "Poppins-Bold", size: 18)
        
        return lbl
    }()
    
    let locationName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 18)
        
        return lbl
    }()
    
    let deliveryTypeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Тип доставки:"
        lbl.font = UIFont(name: "Poppins-Bold", size: 18)
        
        return lbl
    }()
    
    let deliveryTypeName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 18)
        
        return lbl
    }()
    
    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Дата:"
        lbl.font = UIFont(name: "Poppins-Bold", size: 18)
        
        return lbl
    }()
    
    let dateName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 18)
        
        return lbl
    }()
    
    let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Время:"
        lbl.font = UIFont(name: "Poppins-Bold", size: 18)
        
        return lbl
    }()
    
    let timeName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 18)
        
        return lbl
    }()
    
    let minRateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Минимальная ставка:"
        lbl.font = UIFont(name: "Poppins-Bold", size: 18)
        
        return lbl
    }()
    
    let minRateName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 18)
        
        return lbl
    }()
    
    let shiftStatusLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Статус смены:"
        lbl.font = UIFont(name: "Poppins-Bold", size: 18)
        
        return lbl
    }()
    
    let shiftStatusName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Regular", size: 18)
        
        return lbl
    }()
    
    let selectShiftButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Выбрать смену", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGreen
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.darkGray.cgColor
        
        return btn
    }()
    
    let completeShiftButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Завершить смену", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGreen
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.darkGray.cgColor
        
        return btn
    }()
}

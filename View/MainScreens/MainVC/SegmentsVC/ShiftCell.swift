//
//  ShiftCell.swift
//  courierShift
//
//  Created by Татьяна Федотова on 09.05.2025.
//

import UIKit

class ShiftCell: UITableViewCell {
    
    let cellView = UIView()
    let titleStack = UIStackView()
    
    let shiftLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Смена 1:"
        lbl.font = UIFont(name: "Poppins-Regular", size: 16)
        
        return lbl
    }()
    
    let companyLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Самокат"
        lbl.font = UIFont(name: "Poppins-Regular", size: 16)
        
        return lbl
    }()
    
    let timeDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "14:00 - 16:30, 27.12.2025"
        lbl.font = UIFont(name: "Poppins-Regular", size: 20)
        lbl.numberOfLines = 1
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCellView()
        setUpTitleStack()
        setUpTimeDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCellView() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellView)
        cellView.backgroundColor = .systemGray6
        
        cellView.layer.cornerRadius = 10
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.systemGray4.cgColor
        
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    private func setUpTitleStack() {
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleStack)
        
        titleStack.axis = .horizontal
        titleStack.spacing = 4
        
        titleStack.addArrangedSubview(shiftLabel)
        titleStack.addArrangedSubview(companyLabel)
        
        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            titleStack.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 12)
        ])
    }
    
    private func setUpTimeDateLabel() {
        contentView.addSubview(timeDateLabel)
        
        NSLayoutConstraint.activate([
            timeDateLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            timeDateLabel.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 12),
            timeDateLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16)
        ])
    }
    
    func setUpCellData(cellModel: ShiftCellModel) {
        shiftLabel.text = "Смена \(cellModel.shiftId):"
        companyLabel.text = "\(cellModel.companyName ?? "Неизвестная компания")"
        timeDateLabel.text = "\(cellModel.time), \(cellModel.date)"
    }
}

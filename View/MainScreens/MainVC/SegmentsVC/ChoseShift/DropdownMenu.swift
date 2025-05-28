//
//  DropdownMenu.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

/* for use:
 private var dropdownHeightConstraint: NSLayoutConstraint!
 dropdownHeightConstraint = dropdownMenu.heightAnchor.constraint(equalToConstant: dropdownMenu.currentHeight)
 
 dropdownMenu.configure(with: ["Active", "Inactive", "Option 3", "Option 4"])
 
 // Реакция на изменение высоты
 dropdownMenu.onHeightChange = { [weak self] newHeight in
     self?.dropdownHeightConstraint.constant = newHeight
     UIView.animate(withDuration: 0.3) {
         self?.view.layoutIfNeeded()
     }
 }
 */

import UIKit

class DropdownMenu: UIView {
    
    weak var delegate: DropdownMenuDelegate?

    private let button = UIButton()
    private var buttonImage = UIImageView()
    private let contentStack = UIStackView()
    private var applyButton = UIButton()
    private var isOpen = false
    
    private(set) var selectedCompany: CompanyModel?
    
    private(set) var currentHeight: CGFloat = 0 {
        didSet {
            onHeightChange?(currentHeight)
        }
    }

    var onHeightChange: ((CGFloat) -> Void)?
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let startTimePicker = UIDatePicker()
    private let endTimePicker = UIDatePicker()
    private let companyPicker = UIPickerView()
    private var companies: [CompanyModel] = []
    
    private var dateSection = UIView()
    private var timeSection = UIView()
    private var companySection = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func configureCompanies(_ companies: [CompanyModel]) {
        self.companies = companies
        companyPicker.reloadAllComponents()
    }

    private func setupView() {
        //self.backgroundColor = .yellow.withAlphaComponent(1) // Фон для проверки области DropdownMenu
        
        buttonImage = UIImageView(image: .dropdownUp)
        buttonImage.transform = CGAffineTransform(rotationAngle: .pi)
        buttonImage.tintColor = .black
        buttonImage.contentMode = .scaleAspectFit
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Фильтры", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        button.layer.cornerRadius = 9
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        
        button.addSubview(buttonImage)
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),

            buttonImage.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -15),
            buttonImage.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: 17),
            buttonImage.heightAnchor.constraint(equalToConstant: 17)
        ])

        let shadowContainer = UIView()
        shadowContainer.translatesAutoresizingMaskIntoConstraints = false
        shadowContainer.backgroundColor = .white
        shadowContainer.layer.cornerRadius = 12

        // Тень
        shadowContainer.layer.shadowColor = UIColor.black.cgColor
        shadowContainer.layer.shadowOpacity = 0.2
        shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowContainer.layer.shadowRadius = 6

        // Content Stack
        contentStack.axis = .vertical
        contentStack.spacing = 20
        contentStack.isHidden = true
        contentStack.clipsToBounds = true
        contentStack.layer.cornerRadius = 12
        contentStack.layer.borderWidth = 1
        contentStack.layer.borderColor = UIColor.gray.cgColor
        contentStack.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        shadowContainer.addSubview(contentStack)
        addSubview(shadowContainer)

        NSLayoutConstraint.activate([
            shadowContainer.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            shadowContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: shadowContainer.topAnchor),
               contentStack.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor),
               contentStack.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor),
               contentStack.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor)
        ])

        addDateSection()
        addTimeSection()
        addCompanySection()
        addApplyButton()

        currentHeight = calculatedHeight()
    }

    private func addDateSection() {
        let section = UIView()
        section.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Выбрать дату"
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let startLbl = UILabel()
        startLbl.text = "Начало"
        startLbl.font = UIFont(name: "Poppins-Regular", size: 13)
        startLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let endLbl = UILabel()
        endLbl.text = "Конец"
        endLbl.font = UIFont(name: "Poppins-Regular", size: 13)
        endLbl.translatesAutoresizingMaskIntoConstraints = false
        
        startDatePicker.datePickerMode = .date
        startDatePicker.locale = Locale(identifier: "ru_RU")
        endDatePicker.datePickerMode = .date
        endDatePicker.locale = Locale(identifier: "ru_RU")
        endDatePicker.date = Date().addingTimeInterval(60 * 60 * 24 * 3)
        
        let startStack = UIStackView(arrangedSubviews: [startLbl, startDatePicker])
        startStack.axis = .vertical
        startStack.alignment = .center
        startStack.spacing = 2
        startStack.translatesAutoresizingMaskIntoConstraints = false

        let endStack = UIStackView(arrangedSubviews: [endLbl, endDatePicker])
        endStack.axis = .vertical
        endStack.alignment = .center
        endStack.spacing = 2
        endStack.translatesAutoresizingMaskIntoConstraints = false
        
        let pickerStack = UIStackView(arrangedSubviews: [startStack, endStack])
        pickerStack.axis = .horizontal
        pickerStack.spacing = 20
        
        pickerStack.translatesAutoresizingMaskIntoConstraints = false

        section.addSubview(titleLabel)
        section.addSubview(pickerStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: section.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: section.centerXAnchor),
            
            pickerStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            pickerStack.centerXAnchor.constraint(equalTo: section.centerXAnchor),
            
            pickerStack.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -10)
        ])

        self.dateSection = section
        contentStack.addArrangedSubview(dateSection)
    }


    private func addTimeSection() {
        let section = UIView()
        section.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Выбрать время"
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let startLbl = UILabel()
        startLbl.text = "Начало"
        startLbl.font = UIFont(name: "Poppins-Regular", size: 13)
        startLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let endLbl = UILabel()
        endLbl.text = "Конец"
        endLbl.font = UIFont(name: "Poppins-Regular", size: 13)
        endLbl.translatesAutoresizingMaskIntoConstraints = false
        
        startTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
        endTimePicker.date = Date().addingTimeInterval(9999)
        
        let startStack = UIStackView(arrangedSubviews: [startLbl, startTimePicker])
        startStack.axis = .vertical
        startStack.alignment = .center
        startStack.spacing = 2
        startStack.translatesAutoresizingMaskIntoConstraints = false

        let endStack = UIStackView(arrangedSubviews: [endLbl, endTimePicker])
        endStack.axis = .vertical
        endStack.alignment = .center
        endStack.spacing = 2
        endStack.translatesAutoresizingMaskIntoConstraints = false
        
        let pickerStack = UIStackView(arrangedSubviews: [startStack, endStack])
        pickerStack.axis = .horizontal
        pickerStack.spacing = 20
        
        pickerStack.translatesAutoresizingMaskIntoConstraints = false

        section.addSubview(titleLabel)
        section.addSubview(pickerStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: section.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: section.centerXAnchor),
            
            pickerStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            pickerStack.centerXAnchor.constraint(equalTo: section.centerXAnchor),
            
            pickerStack.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -10)
        ])

        self.timeSection = section
        contentStack.addArrangedSubview(timeSection)
    }

    private func addCompanySection() {
        let section = UIView()
        section.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Выбрать компанию"
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        companyPicker.delegate = self
        companyPicker.dataSource = self
        companyPicker.translatesAutoresizingMaskIntoConstraints = false

        section.addSubview(titleLabel)
        section.addSubview(companyPicker)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: section.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: section.centerXAnchor),
            
            companyPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            companyPicker.centerXAnchor.constraint(equalTo: section.centerXAnchor),
            companyPicker.widthAnchor.constraint(equalTo: section.widthAnchor, multiplier: 0.6),
            companyPicker.heightAnchor.constraint(equalTo: companyPicker.widthAnchor, multiplier: 0.3),
            
            companyPicker.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -10)
        ])
        
        self.companySection = section
        contentStack.addArrangedSubview(companySection)
    }
    
    private func addApplyButton() {
        let section = UIView()
        section.translatesAutoresizingMaskIntoConstraints = false
        
        applyButton = UIButton(type: .system)
        applyButton.setTitle("Показать", for: .normal)
        applyButton.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = .black
        applyButton.layer.cornerRadius = 8
        
        applyButton.addTarget(self, action: #selector(applyButtonAction), for: .touchUpInside)
        
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        section.addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            applyButton.topAnchor.constraint(equalTo: section.topAnchor),
            applyButton.centerXAnchor.constraint(equalTo: section.centerXAnchor),
            applyButton.widthAnchor.constraint(equalTo: section.widthAnchor, multiplier: 0.3),
            applyButton.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -10)
        ])
        
        contentStack.addArrangedSubview(section)
    }
    
    @objc private func applyButtonAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = dateFormatter.string(from: startDatePicker.date)
        let endDate = dateFormatter.string(from: endDatePicker.date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let startTime = timeFormatter.string(from: startTimePicker.date)
        let endTime = timeFormatter.string(from: endTimePicker.date)
        
        guard let company = selectedCompany?.name,
              let companyID = selectedCompany?.id
        else { return }
        
        let startAfter = startDate + "T" + startTime
        let endBefore = endDate + "T" + endTime
        
        let filterModel = ShiftFilterDtoModel(
            companyId: companyID,
            startAfter: startAfter,
            endBefore: endBefore)
        
        print("Start date: \(startDate)")
        print("End date: \(endDate)")
        print("Start time: \(startTime)")
        print("End time: \(endTime)")
        print("Company: \(company)")
        print("CompanyID: \(companyID)")
        print("Model: \(filterModel)")
        
        //getFilteredShifts(filterModel: filterModel)
        delegate?.applyShiftsFilter(dtoModel: filterModel)
    }

    @objc private func toggleDropdown() {
        isOpen.toggle()
        
        delegate?.toggleDropdown(isOpen: isOpen)
        
        UIView.animate(withDuration: 0.3) {
            self.contentStack.isHidden = !self.isOpen
            self.buttonImage.transform = self.isOpen ? .identity : CGAffineTransform(rotationAngle: .pi)
            self.currentHeight = self.calculatedHeight()
            self.superview?.layoutIfNeeded()
        }
    }

    private func calculatedHeight() -> CGFloat {
        let baseHeight: CGFloat = 50 // button
        let contentHeightReal = contentStack.frame.height
        let contentHeight: CGFloat = isOpen ? (contentHeightReal + 20) : 0
        return baseHeight + contentHeight
    }
}

extension DropdownMenu: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        companies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedCompany = companies[row]
        return selectedCompany?.name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCompany = companies[row]
    }
}

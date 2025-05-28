//
//  vc.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

import UIKit

class FilterViewController: UIViewController {
    
    // MARK: - UI Elements
    let filterButton = UIButton()
    let filterContainer = UIView()
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let companyPicker = UIPickerView()
    let showButton = UIButton()
    
    // MARK: - State
    var isFilterVisible = false
    let companies = ["Apple", "Google", "Amazon", "Meta", "Netflix"]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupFilterButton()
        setupFilterContainer()
    }
    
    // MARK: - Setup UI
    
    func setupFilterButton() {
        filterButton.setTitle("Фильтры ⬆︎", for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.layer.borderWidth = 1
        filterButton.layer.cornerRadius = 8
        filterButton.addTarget(self, action: #selector(toggleFilter), for: .touchUpInside)
        
        view.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 200),
            filterButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupFilterContainer() {
        filterContainer.layer.cornerRadius = 30
        filterContainer.layer.borderWidth = 1
        filterContainer.alpha = 0
        view.addSubview(filterContainer)
        filterContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterContainer.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10),
            filterContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterContainer.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        setupDatePicker()
        setupTimePicker()
        setupCompanyPicker()
        setupShowButton()
    }
    
    func setupDatePicker() {
        let label = createSectionLabel(text: "Дата")
        filterContainer.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: filterContainer.topAnchor, constant: 20),
            label.centerXAnchor.constraint(equalTo: filterContainer.centerXAnchor)
        ])
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        filterContainer.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            datePicker.centerXAnchor.constraint(equalTo: filterContainer.centerXAnchor)
        ])
    }
    
    func setupTimePicker() {
        let label = createSectionLabel(text: "Время")
        filterContainer.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: filterContainer.centerXAnchor)
        ])
        
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        filterContainer.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            timePicker.centerXAnchor.constraint(equalTo: filterContainer.centerXAnchor)
        ])
    }
    
    func setupCompanyPicker() {
        let label = createSectionLabel(text: "Компания")
        filterContainer.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: filterContainer.centerXAnchor)
        ])
        
        companyPicker.dataSource = self
        companyPicker.delegate = self
        filterContainer.addSubview(companyPicker)
        companyPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            companyPicker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            companyPicker.centerXAnchor.constraint(equalTo: filterContainer.centerXAnchor),
            companyPicker.heightAnchor.constraint(equalToConstant: 80),
            companyPicker.widthAnchor.constraint(equalTo: filterContainer.widthAnchor, multiplier: 0.8)
        ])
    }
    
    func setupShowButton() {
        showButton.setTitle("показать", for: .normal)
        showButton.setTitleColor(.black, for: .normal)
        showButton.layer.borderWidth = 1
        showButton.layer.cornerRadius = 20
        filterContainer.addSubview(showButton)
        showButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showButton.topAnchor.constraint(equalTo: companyPicker.bottomAnchor, constant: 20),
            showButton.centerXAnchor.constraint(equalTo: filterContainer.centerXAnchor),
            showButton.widthAnchor.constraint(equalToConstant: 120),
            showButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.layer.borderWidth = 1
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return label
    }
    
    // MARK: - Actions
    
    @objc func toggleFilter() {
        UIView.animate(withDuration: 0.3) {
            self.filterContainer.alpha = self.isFilterVisible ? 0 : 1
        }
        isFilterVisible.toggle()
    }
}

// MARK: - UIPickerView Data Source & Delegate

extension FilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        companies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        companies[row]
    }
}

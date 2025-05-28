//
//  ShiftDetailsViewController.swift
//  courierShift
//
//  Created by Татьяна Федотова on 10.05.2025.
//

import UIKit

enum ShiftDetailsScreenType {
    case selectShift
    case myShifts
}

class ShiftDetailsViewController: UIViewController {
    
    private let model: ShiftCellModel
    private let build = ShiftDetailsView.shared
    private var screenType: ShiftDetailsScreenType
    
    private var shiftName = UILabel()
    private var companyName = UILabel()
    private var locationName = UILabel()
    private var deliveryTypeName = UILabel()
    private var dateName = UILabel()
    private var timeName = UILabel()
    private var minRateName = UILabel()
    private var shiftStatusName = UILabel()
    
    private let infoStack = UIStackView()
    
    private let companyStack = UIStackView()
    private let locationStack = UIStackView()
    private let deliveryTypeStack = UIStackView()
    private let dateStack = UIStackView()
    private let timeStack = UIStackView()
    private let minRateStack = UIStackView()
    private let shiftStatusStack = UIStackView()
    
    private var selectShiftButton = UIButton()
    private var completeShiftButton = UIButton()

    
    init(model: ShiftCellModel, screenType: ShiftDetailsScreenType) {
        self.model = model
        self.screenType = screenType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Информация о смене"
        
        getShiftInfo(shiftId: model.shiftId)

        setupInfoStack()
        setupShiftName()
        setupButton()
        setupCompleteShiftButton()
    }
    
    private func setupInfoStack() {
        configureStacks()
        
        infoStack.axis = .vertical
        infoStack.spacing = 10
        infoStack.alignment = .center
        
        infoStack.addArrangedSubview(companyStack)
        infoStack.addArrangedSubview(locationStack)
        infoStack.addArrangedSubview(deliveryTypeStack)
        infoStack.addArrangedSubview(dateStack)
        infoStack.addArrangedSubview(timeStack)
        infoStack.addArrangedSubview(minRateStack)
        infoStack.addArrangedSubview(shiftStatusStack)
        
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoStack)
        
        NSLayoutConstraint.activate([
            infoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupShiftName() {
        shiftName = build.shiftName
        view.addSubview(shiftName)
        
        NSLayoutConstraint.activate([
            shiftName.bottomAnchor.constraint(equalTo: infoStack.topAnchor, constant: -10),
            shiftName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureStacks() {
        configureCompanyStack()
        configureLocationStack()
        configureDeliveryTypeStack()
        configureDateStack()
        configureTimeStack()
        configureMinRateStack()
        configureShiftStatusStack()
    }
    
    private func configureCompanyStack() {
        let companyLabel = build.companyLabel
        companyName = build.companyName
        
        companyStack.axis = .horizontal
        companyStack.spacing = 6
        
        companyStack.addArrangedSubview(companyLabel)
        companyStack.addArrangedSubview(companyName)
        
        companyStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(companyStack)
    }
    
    private func configureLocationStack() {
        let locationLabel = build.locationLabel
        locationName = build.locationName
        
        locationStack.axis = .horizontal
        locationStack.spacing = 6
        
        locationStack.addArrangedSubview(locationLabel)
        locationStack.addArrangedSubview(locationName)
        
        locationStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationStack)
    }
    
    private func configureDeliveryTypeStack() {
        let deliveryTypeLabel = build.deliveryTypeLabel
        deliveryTypeName = build.deliveryTypeName
        
        deliveryTypeStack.axis = .horizontal
        deliveryTypeStack.spacing = 6
        
        deliveryTypeStack.addArrangedSubview(deliveryTypeLabel)
        deliveryTypeStack.addArrangedSubview(deliveryTypeName)
        
        deliveryTypeStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deliveryTypeStack)
    }
    
    private func configureDateStack() {
        let dateLabel = build.dateLabel
        dateName = build.dateName
        
        dateStack.axis = .horizontal
        dateStack.spacing = 6
        
        dateStack.addArrangedSubview(dateLabel)
        dateStack.addArrangedSubview(dateName)
        
        dateStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateStack)
    }
    
    private func configureTimeStack() {
        let timeLabel = build.timeLabel
        timeName = build.timeName
        
        timeStack.axis = .horizontal
        timeStack.spacing = 6
        
        timeStack.addArrangedSubview(timeLabel)
        timeStack.addArrangedSubview(timeName)
        
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeStack)
    }
    
    private func configureMinRateStack() {
        let minRateLabel = build.minRateLabel
        minRateName = build.minRateName
        
        minRateStack.axis = .horizontal
        minRateStack.spacing = 6
        
        minRateStack.addArrangedSubview(minRateLabel)
        minRateStack.addArrangedSubview(minRateName)
        
        minRateStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(minRateStack)
    }
    
    private func configureShiftStatusStack() {
        let shiftStatusLabel = build.shiftStatusLabel
        shiftStatusName = build.shiftStatusName
        
        shiftStatusStack.axis = .horizontal
        shiftStatusStack.spacing = 6
        
        shiftStatusStack.addArrangedSubview(shiftStatusLabel)
        shiftStatusStack.addArrangedSubview(shiftStatusName)
        
        shiftStatusStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shiftStatusStack)
    }
    
    private func setupShiftInfo(model: ShiftInfoModel) {
        shiftName.text = "Смена №\(model.id)"
        locationName.text = model.location
        deliveryTypeName.text = model.requiredDeliveryType.rawValue
        minRateName.text = "\(model.minRate)₽"
        shiftStatusName.text = model.status.rawValue
        setupConvertedData(model: self.model)
    }
    
    private func setupButton() {
        selectShiftButton.removeFromSuperview()
        selectShiftButton.removeTarget(nil, action: nil, for: .allEvents)
        
        selectShiftButton = UIButton(type: .system)
        selectShiftButton.translatesAutoresizingMaskIntoConstraints = false
        selectShiftButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        selectShiftButton.setTitleColor(.white, for: .normal)
        selectShiftButton.layer.cornerRadius = 8
        selectShiftButton.layer.borderWidth = 1
        selectShiftButton.layer.borderColor = UIColor.darkGray.cgColor
        
        switch screenType {
        case .selectShift:
            selectShiftButton.setTitle("Бронировать смену", for: .normal)
            selectShiftButton.backgroundColor = .systemGreen
            selectShiftButton.addTarget(self, action: #selector(selectShiftButtonAction), for: .touchUpInside)
        case .myShifts:
            selectShiftButton.setTitle("Отменить бронирование", for: .normal)
            selectShiftButton.backgroundColor = .systemRed
            selectShiftButton.addTarget(self, action: #selector(cancelShiftButtonAction), for: .touchUpInside)
        }
        
        view.addSubview(selectShiftButton)
    
        NSLayoutConstraint.activate([
            selectShiftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectShiftButton.topAnchor.constraint(equalTo: infoStack.bottomAnchor, constant: 25),
            selectShiftButton.widthAnchor.constraint(equalTo: infoStack.widthAnchor, multiplier: 0.8),
            selectShiftButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCompleteShiftButton() {
        if screenType == .myShifts {
            completeShiftButton = build.completeShiftButton
            completeShiftButton.removeFromSuperview()
            completeShiftButton.removeTarget(nil, action: nil, for: .allEvents)
            completeShiftButton.addTarget(self, action: #selector(completeShiftButtonAction), for: .touchUpInside)
            
            view.addSubview(completeShiftButton)
            
            NSLayoutConstraint.activate([
                completeShiftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                completeShiftButton.topAnchor.constraint(equalTo: selectShiftButton.bottomAnchor, constant: 25),
                completeShiftButton.widthAnchor.constraint(equalTo: infoStack.widthAnchor, multiplier: 0.8),
                completeShiftButton.heightAnchor.constraint(equalToConstant: 40)
            ])
            print("TARGETS = ", completeShiftButton.allTargets.count)
        }
    }
    
    @objc private func selectShiftButtonAction() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        ShiftService().selectShift(token: accessToken, shiftId: model.shiftId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let string):
                    print(string)
                    self.showToast(message: string, color: .systemGreen)
                    self.shiftStatusName.text = "BOOKED"
                case .failure(let error):
                    print(error)
                    self.showToast(message: "Не удалось забронировать смену", color: .systemRed)
                }
            }
        }
    }
    
    @objc private func completeShiftButtonAction() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        ShiftService().completeShift(token: accessToken, shiftId: model.shiftId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let string):
                    self.showToast(message: string, color: .systemGreen)
                case .failure(_):
                    self.showToast(message: "Не удалось завершить смену", color: .systemRed)
                }
            }
        }
    }
    
    @objc private func cancelShiftButtonAction() {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        ShiftService().cancelShift(token: accessToken, shiftId: "\(model.shiftId)") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let string):
                    print(string)
                    self.showToast(message: string, color: .systemGreen)
                    self.shiftStatusName.text = "OPEN"
                case .failure(let error):
                    print(error)
                    self.showToast(message: "Не удалось отменить смену", color: .systemRed)
                }
            }
        }
    }
    
    private func showToast(message: String, color: UIColor, duration: Double = 2.0) {
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

    private func setupConvertedData(model: ShiftCellModel) {
        timeName.text = "\(model.time)"
        dateName.text = model.date
        companyName.text = "\(model.companyName ?? "Неизвестная компания")"
    }
    
    private func getShiftInfo(shiftId: Int) {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        ShiftService().getShiftInfo(token: accessToken, shiftId: shiftId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let shiftInfo):
                    self.setupShiftInfo(model: shiftInfo)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

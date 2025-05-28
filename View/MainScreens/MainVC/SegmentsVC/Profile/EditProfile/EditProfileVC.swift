//
//  Untitled.swift
//  courierShift
//
//  Created by Татьяна Федотова on 17.05.2025.
//

import UIKit

class EditProfileVC: UIViewController {
    
    var onDismiss: (() -> Void)?
    
    private let userInfoModel: UserInfoModel
    
    private var textFields = [UserFieldEnum: UITextField]()
    private var updateButton = UIButton()
    
    private let mainStack = UIStackView()
    
    init(model: UserInfoModel) {
        self.userInfoModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.presentationController?.delegate = self
        setupMainStack()
        setupUpdateButton()
    }
    
    private func setupMainStack() {
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)

        for field in UserFieldEnum.allCases {
            let label = UILabel()
            label.text = field.title
            label.font = UIFont(name: "Sen-Bold", size: 16)

            let textField = UITextField()
            textField.placeholder = field.placeHolder
            textField.borderStyle = .roundedRect
            textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            textField.font = UIFont(name: "Poppins-Regular", size: 16)
            
            switch field {
            case .firstName: textField.text = userInfoModel.firstName
            case .surname: textField.text = userInfoModel.surname
            case .middleName: textField.text = userInfoModel.middleName
            case .phone: textField.text = userInfoModel.phone
            case .email: textField.text = userInfoModel.email
            }
            
            textFields[field] = textField

            let fieldStack = UIStackView(arrangedSubviews: [label, textField])
            fieldStack.axis = .vertical
            fieldStack.spacing = 5

            mainStack.addArrangedSubview(fieldStack)
        }

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupUpdateButton() {
        updateButton = UIButton(type: .system)
        updateButton.setTitle("Обновить данные", for: .normal)
        updateButton.titleLabel?.font = UIFont(name: "Poppins-Bold", size: 16)
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.backgroundColor = .black
        updateButton.layer.cornerRadius = 8
        
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(updateButton)
        
        updateButton.addTarget(self, action: #selector(updateButtonAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 40),
            updateButton.widthAnchor.constraint(equalTo: mainStack.widthAnchor, multiplier: 0.6),
            updateButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func updateUserInfo(userInfoModel: UserInfoModel) {
        guard let accessToken = KeychainTokens.standart.read(service: "accessToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        UserService().updateUserInfo(token: accessToken, userInfoModel: userInfoModel) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.showToast(message: "Данные обновлены", color: .systemGreen)
                case .failure(let error):
                    self.showToast(message: "\(error.localizedDescription)", color: .systemRed)
                }
            }
        }
    }
    
    @objc private func updateButtonAction() {
        let userInfoModel = UserInfoModel(
            firstName: textFields[.firstName]?.text ?? "",
            surname: textFields[.surname]?.text ?? "",
            middleName: textFields[.middleName]?.text ?? "",
            phone: textFields[.phone]?.text ?? "No mobile Phone",
            email: textFields[.email]?.text ?? "No email")
        
        self.updateUserInfo(userInfoModel: userInfoModel)
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
}

//
//  RegistrationViewController.swift
//  courierShift
//
//  Created by Татьяна Федотова on 19.01.2025.
//

import Foundation
import UIKit

class RegistrationViewController: UIViewController {
    
    private let build = RegistrationView.shared
    private var titleLabel = UILabel()
    private var textFieldsStack = UIStackView()
    private var scrollViewTextFields = UIScrollView()
    private var continueButton = UIButton()
    private let placeholders = [
        "Фамилия",
        "Имя",
        "Отчество",
        "Номер телефона",
        "Почта",
        "Пароль",
        "Пароль еще раз"
    ]
    private var textFields = [UITextField]()
    private var stacks = [UIStackView]()
    
    //DI
    private var authService = AuthService()
    
    init(authSevice: AuthService) {
        self.authService = authSevice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigationBar()
        
        setTitle()
        setContinueButton()
        setScrollView()
        
        hideKeyboardByTapAnywhere()
    }
    
    private func setUpNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(goBack))
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setTitle() {
        titleLabel = build.titleLabel
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setContinueButton() {
        continueButton = build.continueButton
        view.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(getTextAndGoConfirm), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 45),
            continueButton.widthAnchor.constraint(equalToConstant: 210)
        ])
    }
    
    private func setScrollView() {
        scrollViewTextFields.translatesAutoresizingMaskIntoConstraints = false
        scrollViewTextFields.showsVerticalScrollIndicator = false
        view.addSubview(scrollViewTextFields)
        
        NSLayoutConstraint.activate([
            scrollViewTextFields.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            scrollViewTextFields.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            scrollViewTextFields.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            scrollViewTextFields.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -40)
        ])
        setTextStacks()
    }
    
    private func setTextStacks() {
        textFields = placeholders.map({ _ in
            UITextField()
        })
        
        for (index, placeholder) in placeholders.enumerated() {
            let isPassword = placeholder.contains("Пароль")
            if isPassword {
                textFields[index].textContentType = .oneTimeCode
            }
            let stack = build.getTextView(textField: textFields[index], placeholder: placeholder, hint: placeholder, isPassword: isPassword)
            stacks.append(stack)
        }
        
        textFieldsStack = UIStackView(arrangedSubviews: stacks)
        textFieldsStack.axis = .vertical
        textFieldsStack.spacing = 5
        textFieldsStack.translatesAutoresizingMaskIntoConstraints = false
        scrollViewTextFields.addSubview(textFieldsStack)
        
        let textFieldStackWidth = view.frame.width - 32*2
        
        NSLayoutConstraint.activate([
            textFieldsStack.leadingAnchor.constraint(equalTo: scrollViewTextFields.leadingAnchor),
            textFieldsStack.trailingAnchor.constraint(equalTo: scrollViewTextFields.trailingAnchor),
            textFieldsStack.widthAnchor.constraint(equalToConstant: textFieldStackWidth),
            textFieldsStack.topAnchor.constraint(equalTo: scrollViewTextFields.topAnchor),
            textFieldsStack.bottomAnchor.constraint(equalTo: scrollViewTextFields.bottomAnchor)
        ])
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    private func goConfirmEmailScreen(signUpModel: SignUpModel) {
        //go confirmScreen
        let confirmEmailVC = ConfirmEmailViewController(authService: authService, signUpModel: signUpModel)
        self.navigationController?.pushViewController(confirmEmailVC, animated: true)
    }
    
    @objc private func getTextAndGoConfirm() {
        let enteredTexts = textFields.map { $0.text ?? "" }
        
        guard enteredTexts.allSatisfy({ !$0.isEmpty }) else {
            self.showErrorAlert(message: "Заполните все поля")
            return
        }
        
        if enteredTexts[5] != enteredTexts[6] {
            self.showErrorAlert(message: "Пароли не совпадают")
            return
        }
        
        let signUpModel = SignUpModel(
            email: enteredTexts[4],
            password: enteredTexts[5],
            firstName: enteredTexts[1],
            surname: enteredTexts[0],
            middleName: enteredTexts[2],
            phoneNumber: enteredTexts[3]
        )
        
        authService.signUp(signUpModel: signUpModel) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Успешно: \(response)")
                    
                    self.goConfirmEmailScreen(signUpModel: signUpModel)
                    
                case .failure(let error):
                    print("Ошибка регистрации \(error)")
                    
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
        
        if let jsonData = try? JSONEncoder().encode(signUpModel),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON String:\n\(jsonString)")
        }
    }
}

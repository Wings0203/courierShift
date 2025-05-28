//
//  ViewController.swift
//  courierShift
//
//  Created by Татьяна Федотова on 18.01.2025.
//

import UIKit

class LoginViewController: UIViewController {

    private let build = LoginView.shared
    private var titleLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private var passwordStack = UIStackView()
    private var loginButton = UIButton()
    private var createAccountButton = UIButton()
    private var textFieldsStack = UIStackView()
    private let placeholders = ["Почта", "Пароль"]
    private var textFields = [UITextField]()
    private var stacks = [UIStackView]()
    
    //DI
    private var authService = AuthService()
    
    init(authService: AuthService) {
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        setTitle()
        setTextFields()
        setButton()
        setNoAccountWithButton()
        
        hideKeyboardByTapAnywhere()
    }
    
    private func setTitle() {
        titleLabel = build.titleLabel
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 170)
        ])
    }
    
    private func setTextFields() {
        textFields = placeholders.map({ _ in
            UITextField()
        })
        
        for (index, placeholder) in placeholders.enumerated() {
            let isPassword = placeholder.contains("Пароль")
            if isPassword {
                textFields[index].textContentType = .oneTimeCode
            }
            let stack = build.getTextView(textField: textFields[index], placeholder: placeholder, isPassword: isPassword)
            stacks.append(stack)
        }
        
        textFieldsStack = UIStackView(arrangedSubviews: stacks)
        textFieldsStack.axis = .vertical
        textFieldsStack.spacing = 20
        textFieldsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textFieldsStack)
        
        NSLayoutConstraint.activate([
            textFieldsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textFieldsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            textFieldsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70),
        ])
    }
    
    private func setButton() {
        loginButton = build.loginButton
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(getTextAndGoMainScreen), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 45),
            loginButton.widthAnchor.constraint(equalToConstant: 210),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: 108)
        ])
    }
    
    private func setNoAccountWithButton() {
        let noAccountWithButtonStack = build.getNoAccountStack(createAccountButton: createAccountButton)
        view.addSubview(noAccountWithButtonStack)
        createAccountButton.addTarget(self, action: #selector(goToRegistration), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            noAccountWithButtonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noAccountWithButtonStack.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 108),
            noAccountWithButtonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    private func goToMainScreen() {
        let mainVC = MainViewController()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else { return }
        
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        UIView.transition(with: keyWindow, duration: 0.5, options: .transitionCurlDown) {
            keyWindow.rootViewController = navigationController
            keyWindow.makeKeyAndVisible()
        }
    }
    
    private func saveTokensToKeychain(tokens: TokensModel, loginModel: LoginModel) {
        KeychainTokens.standart.save(tokens.accessToken, service: "accessToken", account: loginModel.email)
        KeychainTokens.standart.save(tokens.refreshToken, service: "refreshToken", account: loginModel.email)
    }
    
    @objc func goToRegistration() {
        let registrationViewController = RegistrationViewController(authSevice: authService)
        navigationController?.pushViewController(registrationViewController, animated: true)
        
    }
    
    @objc private func getTextAndGoMainScreen() {
        let enteredTexts = textFields.map { $0.text ?? "" }
        
        guard enteredTexts.allSatisfy({ !$0.isEmpty }) else { return }
        
        let loginModel = LoginModel(email: enteredTexts[0], password: enteredTexts[1])
        
        if let jsonData = try? JSONEncoder().encode(loginModel),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Json data: \(jsonString)")
        }
        
        authService.logIn(email: loginModel.email, password: loginModel.password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokens):
                    print("Успешный вход AccessToken: \(tokens.accessToken)")
                    
                    UserDefaults.standard.setValue(true, forKey: "isAuthorized")
                    
//                    UserDefaults.standard.removeObject(forKey: "accessToken")
//                    UserDefaults.standard.removeObject(forKey: "refreshToken")

                    self.saveTokensToKeychain(tokens: tokens, loginModel: loginModel)
                    self.goToMainScreen()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
}

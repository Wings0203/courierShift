//
//  ConfirmEmailViewController.swift
//  courierShift
//
//  Created by Татьяна Федотова on 19.01.2025.
//

import Foundation
import UIKit

class ConfirmEmailViewController: UIViewController {
    
    private let build = ConfirmEmailView.shared
    private var titleLabel = UILabel()
    private var infoLabel = UILabel()
    private var confirmButton = UIButton()
    private var sendMessageButton = UIButton()
    private var sendMessageStack = UIStackView()
    private var countdownLabel = UILabel()
    
    private let numberOfFields = 6
    private var textFields = [UITextField]()
    private var otpStack = UIStackView()
    
    private var resendCountdownTime = 10
    
    //DI
    private var authService = AuthService()
    private var signUpModel: SignUpModel
    
    init(authService: AuthService, signUpModel: SignUpModel) {
        self.authService = authService
        self.signUpModel = signUpModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        setTitleLabel()
        setInfoLabel()
        setupOTPFields()
        setConfirmButton()
        setSendMessageStack()
        startResendCountdown(from: resendCountdownTime)
    }
    
    private func setTitleLabel() {
        titleLabel = build.titleLabel
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70)
        ])
    }
    
    private func setInfoLabel() {
        infoLabel = build.infoLabel
        view.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor)
        ])
    }
    
    private func setupOTPFields() {
        otpStack.axis = .horizontal
        otpStack.distribution = .fillEqually
        otpStack.spacing = 10
        
        for _ in 0..<numberOfFields {
            let textField = UITextField()
            textField.textAlignment = .center
            textField.font = AppTheme.Fonts.otpNumber
            textField.keyboardType = .numberPad
            textField.layer.cornerRadius = 10
            textField.backgroundColor = .placeholderBackground
            textField.tintColor = .black
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChangeSelection(_:)), for: .editingChanged)
            
            NSLayoutConstraint.activate([
                textField.heightAnchor.constraint(equalTo: textField.widthAnchor)
            ])
            
            otpStack.addArrangedSubview(textField)
            textFields.append(textField)
        }
        
        otpStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(otpStack)
        
        NSLayoutConstraint.activate([
            otpStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            otpStack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            otpStack.heightAnchor.constraint(equalToConstant: (view.bounds.width - 40 - CGFloat(10*numberOfFields))/6)
        ])
    }
    
    private func getOTPCode() -> String {
        return textFields.compactMap { $0.text }.joined()
    }
    
    private func setConfirmButton() {
        confirmButton = build.confirmButton
        view.addSubview(confirmButton)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: otpStack.bottomAnchor, constant: 86),
            confirmButton.heightAnchor.constraint(equalToConstant: 45),
            confirmButton.widthAnchor.constraint(equalToConstant: 210)
        ])
    }
    
    private func setSendMessageStack() {
        sendMessageButton.addTarget(self, action: #selector(resendVerificationCode), for: .touchUpInside)
        sendMessageStack = build.getSendMessageStack(sendMessageButton: sendMessageButton)
        view.addSubview(sendMessageStack)
        
        NSLayoutConstraint.activate([
            sendMessageStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendMessageStack.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 86)
        ])
    }
    
    private func startResendCountdown(from seconds: Int) {
        countdownLabel = build.countdownLabel
        
        var remainingSeconds = seconds
        sendMessageButton.isEnabled = false
        sendMessageButton.alpha = 0.6

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            remainingSeconds -= 1
            self.countdownLabel.text = "\(remainingSeconds)..."

            if remainingSeconds <= 0 {
                timer.invalidate()
                self.sendMessageButton.isEnabled = true
                self.sendMessageButton.alpha = 1.0
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    private func goToMainScreen(signUpModel: SignUpModel) {
        setTokens(signUpModel: signUpModel)
        
        let mainVC = MainViewController()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first else { return }
        
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        UIView.transition(with: keyWindow, duration: 0.5, options: .transitionCurlDown) {
            keyWindow.rootViewController = navigationController
            keyWindow.makeKeyAndVisible()
        }
    }
    
    private func setTokens(signUpModel: SignUpModel) {
        
        authService.logIn(email: signUpModel.email, password: signUpModel.password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokens):
                    print("Успешный вход AccessToken: \(tokens.accessToken)")
                    
//                    UserDefaults.standard.setValue(tokens.accessToken, forKey: "accessToken")
//                    UserDefaults.standard.setValue(tokens.refreshToken, forKey: "refreshToken")

                    self.saveTokensToKeychain(tokens: tokens)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func saveTokensToKeychain(tokens: TokensModel) {
        KeychainTokens.standart.save(tokens.accessToken, service: "accessToken", account: signUpModel.email)
        KeychainTokens.standart.save(tokens.refreshToken, service: "refreshToken", account: signUpModel.email)
    }
    
    @objc private func resendVerificationCode() {
        authService.resendVerificationCode(signUpModel: signUpModel) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("Успех: \(message)")
                    
                    self.startResendCountdown(from: self.resendCountdownTime)
                    self.showSuccessAlert(message: "Код подтверждения снова отправлен")
                case .failure(let error):
                    print("Ошибка: \(error)")
                    
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func confirmButtonAction() {
        let otpCode = getOTPCode()
        if otpCode.count == 6 {
            
            authService.verifyAccount(signUpModel: signUpModel, verifyCode: otpCode) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("Успешно: \(response)")
                        
                        UserDefaults.standard.setValue(true, forKey: "isAuthorized")
                        self.goToMainScreen(signUpModel: self.signUpModel)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                        self.showErrorAlert(message: error.localizedDescription)
                    }
                }
                }
            print(otpCode)
            }
        }
}

extension ConfirmEmailViewController: UITextFieldDelegate {
    
    @objc internal func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, text.count == 1 else { return }
        
        if let currentIndex = textFields.firstIndex(of: textField), currentIndex < textFields.count - 1 {
            textFields[currentIndex + 1].becomeFirstResponder()
        }
        
        if textFields.last == textField {
            textField.resignFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let allowedCharacterSet = CharacterSet.decimalDigits
        let isBackspace = string.isEmpty
        let isValidCharacter = string.rangeOfCharacter(from: allowedCharacterSet) != nil || isBackspace

        let currentText = textField.text ?? ""
        let newLength = currentText.count + string.count - range.length

        return isValidCharacter && newLength <= 1
    }
}

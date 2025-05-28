//
//  LoginView.swift
//  courierShift
//
//  Created by Татьяна Федотова on 18.01.2025.
//

import Foundation
import UIKit

class LoginView {
    
    //make it singletone
    static let shared = LoginView()
    private init() {}
    
    lazy var titleLabel: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = AppTheme.Fonts.titleFont
        lbl.text = "Авторизация"
        lbl.textColor = .black
        
        return lbl
    }()
    
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 10
        btn.setTitle("Войти", for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.titleLabel?.font = AppTheme.Fonts.authorizationButton
        btn.titleLabel?.textColor = .white
        
        return btn
    }()
    
    func getNoAccountStack(createAccountButton: UIButton) -> UIStackView {
        
        lazy var noAccountLabel: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = AppTheme.Fonts.authorizationText
            lbl.text = "Нет аккаунта?"
            lbl.textColor = .black
            lbl.layer.opacity = 0.6
            
            return lbl
        }()

        createAccountButton.setTitle("Создать", for: .normal)
        createAccountButton.setTitleColor(.black.withAlphaComponent(0.6), for: .normal)
        createAccountButton.setTitleColor(.black.withAlphaComponent(0.3), for: .highlighted)
        createAccountButton.titleLabel?.font = AppTheme.Fonts.authorizationButton
        createAccountButton.tintAdjustmentMode = .automatic
        
        lazy var hStack: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.spacing = 8
            
            stack.addArrangedSubview(noAccountLabel)
            stack.addArrangedSubview(createAccountButton)
            
            return stack
        }()

        return hStack
    }
    
    func getTextView(textField: UITextField, placeholder: String, isPassword: Bool = false) -> UIStackView {
        
        lazy var hidePasswordButton : UIButton = {
            let button = UIButton(primaryAction: action)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            button.tintColor = .systemGray
            
            return button
        }()
        
        lazy var action = UIAction { _ in
            textField.isSecureTextEntry.toggle()
            
            if textField.isSecureTextEntry {
                hidePasswordButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            } else {
                hidePasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)

            }
        }
        
        lazy var placeholderText: UIView = {
            
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.text = placeholder
            text.textColor = .black
            text.font = AppTheme.Fonts.textFieldPlaceholder
            
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(text)
            
            text.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            view.heightAnchor.constraint(equalToConstant: 16).isActive = true
            
            return view
        }()
        
        lazy var fieldView: UIView = {
           
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(textField)
            
            view.layer.cornerRadius = 15
            view.backgroundColor = .placeholderBackground

            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.isSecureTextEntry = isPassword
            if isPassword {
                textField.placeholder = " yourpassword"
            } else {
                textField.placeholder = "your@gmail.com"
            }
            
            if isPassword {
                view.addSubview(hidePasswordButton)
                
                NSLayoutConstraint.activate([
                    hidePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    hidePasswordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }
            
            textField.autocapitalizationType = .none
            
            NSLayoutConstraint.activate([
                textField.topAnchor.constraint(equalTo: view.topAnchor),
                textField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                view.heightAnchor.constraint(equalToConstant: 62)
            ])
            
            return view
        }()
        
        lazy var vStack: UIStackView = {
            
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.spacing = 10
            
            stack.addArrangedSubview(placeholderText)
            stack.addArrangedSubview(fieldView)
            
            return stack
        }()
        
        return vStack
    }
}


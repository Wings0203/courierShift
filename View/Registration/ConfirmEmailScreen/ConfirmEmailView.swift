//
//  ConfirmEmailView.swift
//  courierShift
//
//  Created by Татьяна Федотова on 19.01.2025.
//

import Foundation
import UIKit

class ConfirmEmailView {
    
    //make it singletone
    static let shared = ConfirmEmailView()
    private init() {}
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = AppTheme.Fonts.titleFont
        lbl.text = "Подтверждение"
        lbl.textColor = .black
        
        return lbl
    }()
    
    lazy var infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = AppTheme.Fonts.textFieldPlaceholder
        lbl.textColor = .black
        lbl.text = """
        На вашу почту был отправлен код
        подтверждения.
        Введите его ниже, чтобы завершить
        регистрацию.
        """
        
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 10
        btn.setTitle("Подтвердить", for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.titleLabel?.font = AppTheme.Fonts.authorizationButton
        btn.titleLabel?.textColor = .white
        
        return btn
    }()
    
    lazy var countdownLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = AppTheme.Fonts.authorizationText
        lbl.text = ""
        lbl.textColor = .black
        lbl.layer.opacity = 0.6
        return lbl
    }()

    
    func getSendMessageStack(sendMessageButton: UIButton) -> UIStackView {

        sendMessageButton.setTitle("Отправить снова", for: .normal)
        sendMessageButton.setTitleColor(.black.withAlphaComponent(0.6), for: .normal)
        sendMessageButton.setTitleColor(.black.withAlphaComponent(0.3), for: .highlighted)
        sendMessageButton.titleLabel?.font = AppTheme.Fonts.authorizationButton
        sendMessageButton.tintAdjustmentMode = .automatic
        
        lazy var throughLabel: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.font = AppTheme.Fonts.authorizationText
            lbl.text = "через"
            lbl.textColor = .black
            lbl.layer.opacity = 0.6
            
            return lbl
        }()
        
        lazy var hStack: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.spacing = 8
            
            stack.addArrangedSubview(sendMessageButton)
            stack.addArrangedSubview(throughLabel)
            stack.addArrangedSubview(countdownLabel)
            
            return stack
        }()

        return hStack
    }
}

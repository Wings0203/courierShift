//
//  LoginKeyboadrExtention.swift
//  courierShift
//
//  Created by Татьяна Федотова on 19.01.2025.
//

import Foundation
import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    func hideKeyboardByTapAnywhere() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardAfterButtonPressed() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

//
//  RefreshTokenLogin.swift
//  courierShift
//
//  Created by Татьяна Федотова on 13.05.2025.
//

import Foundation

//it will be here, i will move it
class RefreshTokenLogin {
    private func testRefreshToken() {
        guard let token = KeychainTokens.standart.read(service: "refreshToken", account: "londxz@yandex.ru", type: String.self) else { return }
        
        AuthService().refreshToken(token: token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokens):
                    print("success, \(tokens)")
                    self.saveTokensToKeychain(tokens: tokens, email: "londxz@yandex.ru")
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        }
    }
    
    private func saveTokensToKeychain(tokens: TokensModel, email: String) {
        KeychainTokens.standart.save(tokens.accessToken, service: "accessToken", account: email)
        KeychainTokens.standart.save(tokens.refreshToken, service: "refreshToken", account: email)
    }
}

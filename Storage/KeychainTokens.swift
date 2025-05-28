//
//  KeychainTokens.swift
//  courierShift
//
//  Created by Татьяна Федотова on 07.05.2025.
//

import Foundation
import Security

class KeychainTokens {
    static let standart = KeychainTokens()
    
    private init() {}
    
    func save<T: Codable>(_ item: T, service: String, account: String) {
        let data = try? JSONEncoder().encode(item)
        guard let data = data else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
        print("DEBUG: KeychainTokens saved")
    }
    
    func read<T: Codable>(service: String, account: String, type: T.Type) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let object = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }
        
        print("DEBUG: KeychainTokens read")
        return object
    }
    
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
        print("DEBUG: KeychainTokens delete")
    }
}

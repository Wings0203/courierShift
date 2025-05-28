//
//  UserService.swift
//  courierShift
//
//  Created by Татьяна Федотова on 17.05.2025.
//

import Foundation

class UserService {
    
    private lazy var networkConfig = NetworkConfig.shared
    
    func getUserInfo(token: String, completion: @escaping(Result<UserInfoModel, Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.getUserInfoPath
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, httpResponse, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = httpResponse as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "UserService/getUserInfo", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "UserService/getUserInfo", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                do {
                    let userInfo = try JSONDecoder().decode(UserInfoModel.self, from: data)
                    completion(.success(userInfo))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func updateUserInfo(token: String, userInfoModel: UserInfoModel, completion: @escaping (Result<String, Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.updateUserInfoPath
        
        let postData = ["firstName": userInfoModel.firstName,
                        "surname": userInfoModel.surname,
                        "middleName": userInfoModel.middleName,
                        "phone": userInfoModel.phone,
                        "email": userInfoModel.email]
        
        guard let httpBody = try? JSONEncoder().encode(postData) else {
            return completion(.failure(NSError(domain: "UserService/updateUserInfo", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка кодирования данных"])))
        }
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { (data, httpResponse, error) in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = httpResponse as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "UserService/updateUserInfo", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "UserService/updateUserInfo", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                if let response = String(data: data, encoding: .utf8) {
                    completion(.success(response))
                } else {
                    let decodingError = NSError(domain: "UserService/updateUserInfo", code: 3, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать ответ как строку"])
                    completion(.failure(decodingError))
                }
            }.resume()
        }
    }
    
    func deleteUser(token: String, email: String, completion: @escaping(Result<String, Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.deleteUserPath
        urlComponents.queryItems = [URLQueryItem(name: "email", value: email)]
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, httpResponse, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = httpResponse as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "UserService/deleteUser", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "UserService/deleteUser", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                if let response = String(data: data, encoding: .utf8) {
                    completion(.success(response))
                } else {
                    let decodingError = NSError(domain: "UserService/deleteUser", code: 3, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать ответ как строку"])
                    completion(.failure(decodingError))
                }
            }.resume()
        }
    }
}

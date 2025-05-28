//
//  AuthService.swift
//  courierShift
//
//  Created by Татьяна Федотова on 28.02.2025.
//

import Foundation

class AuthService {
    
    private lazy var networkConfig = NetworkConfig.shared
    
    func signUp(signUpModel: SignUpModel, completion: @escaping (Result<String, Error>) -> Void) {
        
        //create url
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.signUpPath
        
        //post data
        guard let httpBody = try? JSONEncoder().encode(signUpModel) else {
            return completion(.failure(NSError(domain: "AuthService/signUp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка кодирования данных"])))
        }
        
        //create request
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            //send request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                //Check that httpcode is 200
                if let httpResponse = response as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "AuthService/signUp", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard data != nil else {
                    completion(.failure(NSError(domain: "AuthService/signUp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                // Успешный ответ
                DispatchQueue.main.async {
                    completion(.success("Код для регистрации отправлен"))
                }
                
                
            }.resume()
        }
    }
    
    func verifyAccount(signUpModel: SignUpModel, verifyCode: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        //Create url
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.verifyAccountPath
        
        //post data
        let postData = ["email": signUpModel.email, "verificationCode": verifyCode]
        guard let httpBody = try? JSONEncoder().encode(postData) else {
            return completion(.failure(NSError(domain: "AuthService/verifyAccount", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка кодирования данных"])))
        }
        
        //create request
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            //send request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                //Check that httpcode is 200
                if let httpResponse = response as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "AuthService/verifyAccount", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard data != nil else {
                    completion(.failure(NSError(domain: "AuthService/verifyAccount", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                // Успешный ответ
                DispatchQueue.main.async {
                    completion(.success("Регистрация прошла успешно"))
                }
            }.resume()
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping(Result<TokensModel, Error>) -> Void) {
        
        //Create url
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.loginPath
        
        let postData = LoginModel(email: email, password: password)
        
        guard let httpBody = try? JSONEncoder().encode(postData) else {
            return completion(.failure(NSError(domain: "AuthService/logIn", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка кодирования данных"])))
        }
        
        //Create request
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            //Send request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                //Check that httpcode is 200
                if let httpResponse = response as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "AuthService/logIn", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "AuthService/logIn", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                //Decode response json
                do {
                    let tokens = try JSONDecoder().decode(TokensModel.self, from: data)
                    completion(.success(tokens))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
        
    func resendVerificationCode(signUpModel: SignUpModel, completion: @escaping(Result<String, Error>) -> Void) {
            
            //Create url
            var urlComponents = URLComponents()
            urlComponents.scheme = "http"
            urlComponents.host = networkConfig.host
            urlComponents.port = networkConfig.port
            urlComponents.path = networkConfig.resendVerificationCodePath
            urlComponents.queryItems = [URLQueryItem(name: "email", value: signUpModel.email)]
        
        guard let url = urlComponents.url else {
            return completion(.failure(NSError(domain: "AuthService/resendVerification", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка формирования URL"])))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Check that httpcode is 200
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP статус код: \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "AuthService/resendVerification", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                // Успешный ответ
                DispatchQueue.main.async {
                    completion(.success("Код подтверждения повторно отправлен"))
                }
            }.resume()
    }
    
    func refreshToken(token: String, completion: @escaping(Result<TokensModel, Error>) -> Void) {
        
        //Create url
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.refreshTokenPath
        
        //post data
        let postData = ["refreshToken": token]
        guard let httpBody = try? JSONEncoder().encode(postData) else {
            return completion(.failure(NSError(domain: "AuthService/refreshToken", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка кодирования данных"])))
        }
        
        //Create request
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            //Send request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                //Check that httpcode is 200
                if let httpResponse = response as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "AuthService/refreshToken", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "AuthService/refreshToken", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                //Decode response json
                do {
                    let tokens = try JSONDecoder().decode(TokensModel.self, from: data)
                    completion(.success(tokens))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}

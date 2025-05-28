//
//  ShiftService.swift
//  courierShift
//
//  Created by Татьяна Федотова on 10.05.2025.
//

import Foundation

class ShiftService {
    
    private lazy var networkConfig = NetworkConfig.shared
    
    func getAvaliableShifts(token: String, completion: @escaping (Result<[ShiftDetailsModel], Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.getAvaliableShiftsPath
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "ShiftService/getAvaliableShifts", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "ShiftService/getAvaliableShifts", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                do {
                    let shifts = try JSONDecoder().decode([ShiftDetailsModel].self, from: data)
                    completion(.success(shifts))
                } catch {
                    completion(.failure(error))
                }
                
            }.resume()
        }
    }
    
    func getShiftInfo(token: String, shiftId: Int, completion: @escaping(Result<ShiftInfoModel, Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = "\(networkConfig.getShiftInfo)/\(shiftId)"
        
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
                        completion(.failure(NSError(domain: "ShiftService/getShiftInfo", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "ShiftService/getShiftInfo", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                do {
                    let shiftInfo = try JSONDecoder().decode(ShiftInfoModel.self, from: data)
                    completion(.success(shiftInfo))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func selectShift(token: String, shiftId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = "\(networkConfig.selectShiftPath)/\(shiftId)"
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
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
                        completion(.failure(NSError(domain: "ShiftService/selectShift", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "ShiftService/selectShift", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                if let response = String(data: data, encoding: .utf8) {
                    completion(.success(response))
                } else {
                    let decodingError = NSError(domain: "ShiftService/selectShift", code: 3, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать ответ как строку"])
                    completion(.failure(decodingError))
                }
            }.resume()
        }
    }
    
    func getSelectedShifts(token: String, completion: @escaping(Result<[ShiftDetailsModel], Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.selectedShiftsPath
        
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
                        completion(.failure(NSError(domain: "ShiftService/getSelectedShifts", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "ShiftService/getSelectedShifts", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                do {
                    let shiftInfo = try JSONDecoder().decode([ShiftDetailsModel].self, from: data)
                    completion(.success(shiftInfo))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func cancelShift(token: String, shiftId: String, completion: @escaping(Result<String, Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = "\(networkConfig.cancelShiftPath)/\(shiftId)/cancel"
        
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
                        completion(.failure(NSError(domain: "ShiftService/cancelShift", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "ShiftService/cancelShift", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                if let response = String(data: data, encoding: .utf8) {
                    completion(.success(response))
                } else {
                    let decodingError = NSError(domain: "ShiftService/cancelShift", code: 3, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать ответ как строку"])
                    completion(.failure(decodingError))
                }
            }.resume()
        }
    }
    
    func getFilteredShifts(token: String, filterModel: ShiftFilterDtoModel, completion: @escaping(Result<[ShiftDetailsModel], Error>) -> Void) {

        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.getFilteredShiftsPath
        
        guard let httpBody = try? JSONEncoder().encode(filterModel) else {
            return completion(.failure(NSError(domain: "ShiftService/getFilteredShifts", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ошибка кодирования данных"])))
        }
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "ShiftService/getFilteredShifts", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "ShiftService/getFilteredShifts", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                do {
                    let filteredShifts = try JSONDecoder().decode([ShiftDetailsModel].self, from: data)
                    completion(.success(filteredShifts))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func getCompletedShiftsCountInfo(token: String, completion: @escaping(Result<String, Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.getCompletedShiftsCountPath
        
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
                        completion(.failure(NSError(domain: "UserService/getCompletedShiftsCountInfo", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "UserService/getCompletedShiftsCountInfo", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                if let count = String(data: data, encoding: .utf8) {
                    completion(.success(count))
                } else {
                    let decodingError = NSError(domain: "UserService/getCompletedShiftsCountInfo", code: 3, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать ответ как строку"])
                    completion(.failure(decodingError))
                }
            }.resume()
        }
    }
    
    func completeShift(token: String, shiftId: Int, completion: @escaping (Result<String, Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = "\(networkConfig.completeShift)/\(shiftId)"
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
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
                        completion(.failure(NSError(domain: "UserService/completeShift", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "UserService/completeShift", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                if let response = String(data: data, encoding: .utf8) {
                    completion(.success(response))
                } else {
                    let decodingError = NSError(domain: "UserService/completeShift", code: 3, userInfo: [NSLocalizedDescriptionKey: "Не удалось декодировать ответ как строку"])
                    completion(.failure(decodingError))
                }
            }.resume()
        }
    }
}

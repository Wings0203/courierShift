//
//  CompanyService.swift
//  courierShift
//
//  Created by Татьяна Федотова on 11.05.2025.
//

import Foundation

class CompanyService {
    
    private lazy var networkConfig = NetworkConfig.shared
    
    func getAllCompanies(token: String, completion: @escaping (Result<[CompanyModel], Error>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = networkConfig.host
        urlComponents.port = networkConfig.port
        urlComponents.path = networkConfig.getAllCompanies
        
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("Http status code is \(httpResponse.statusCode)")
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let errorMessage = "Ошибка сервера: \(httpResponse.statusCode)"
                        completion(.failure(NSError(domain: "CompanyService/getAllCompanies", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "CompanyService/getAllCompanies", code: 2, userInfo: [NSLocalizedDescriptionKey: "Пустой ответ от сервера"])))
                    return
                }
                
                do {
                    let companies = try JSONDecoder().decode([CompanyModel].self, from: data)
                    //print("\n\(companies)\n")
                    completion(.success(companies))
                } catch {
                    completion(.failure(error))
                }
                
            }.resume()
        }
    }
}

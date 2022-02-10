//
//  ApiRequestDispatcher.swift
//  NetworkWrapper
//
//  Created by Max Ward on 09/06/2021.
//
import Foundation
import UIKit

enum APIError: Error {
    case noData
    case invalidResponse
    case badRequest(String?)
    case serverError(String?)
    case parseError(String?)
    case unknown
}

protocol RequestDispatcherProtocol {
    init(networkSession: NetworkSessionProtocol, environment: EnvironmentProtocol?)
    func execute<T: Codable>(request: RequestProtocol, of type: T.Type, completion: @escaping (Result<T?, APIError>) -> Void)
}

class RequestDispatcher: RequestDispatcherProtocol {
    
    private var environment: EnvironmentProtocol?
    
    private var networkSession: NetworkSessionProtocol
    
    fileprivate static var globalEnvironment: EnvironmentProtocol?
    
    required init(networkSession: NetworkSessionProtocol, environment: EnvironmentProtocol? = nil) {
        self.networkSession = networkSession
        self.environment = environment
    }
    
    func execute<T: Codable>(request: RequestProtocol, of type: T.Type, completion: @escaping (Result<T?, APIError>) -> Void) {
        
        guard var urlRequest = request.urlRequest(with: environment) else {
            return
        }
        
        environment?.headers?.forEach({ (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        })
        
        var task: URLSessionTask?
        task = networkSession.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
            guard let response = urlResponse as? HTTPURLResponse else {
                completion(.failure(.badRequest("bad request")))
                return
            }
            completion(self.verify(data: data, of: T.self, urlResponse: response , error: error))
        })
        
        task?.resume()
    }
    
    private func verify<T: Codable>(data: Any?, of type: T.Type, urlResponse: HTTPURLResponse, error: Error?) -> Result<T?, APIError> {
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                let jsonDecoder = JSONDecoder()
                do {
                    let decodedData = try jsonDecoder.decode(T.self, from: data as! Data)
                    return .success(decodedData)
                } catch {
                    return .failure(APIError.unknown)
                }
            } else {
                return .failure(APIError.noData)
            }
        case 400...499:
            return .failure(APIError.badRequest(error?.localizedDescription))
        case 500...599:
            return .failure(APIError.serverError(error?.localizedDescription))
        default:
            return .failure(APIError.unknown)
        }
    }
}

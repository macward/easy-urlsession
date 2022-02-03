//
//  ApiRequestDispatcher.swift
//  NetworkWrapper
//
//  Created by Max Ward on 09/06/2021.
//
import Foundation

/// Enum of API Errors
enum APIError: Error {
    /// No data received from the server.
    case noData
    /// The server response was invalid (unexpected format).
    case invalidResponse
    /// The request was rejected: 400-499
    case badRequest(String?)
    /// Encoutered a server error.
    case serverError(String?)
    /// There was an error parsing the data.
    case parseError(String?)
    /// Unknown error.
    case unknown
}

protocol RequestDispatcherProtocol {
    init(networkSession: NetworkSessionProtocol)
    func execute<T: Codable>(request: RequestProtocol, of type: T.Type, completion: @escaping (T) -> Void)
}

class RequestDispatcher: RequestDispatcherProtocol {
    
    private var environment: EnvironmentProtocol

    private var networkSession: NetworkSessionProtocol
    
    fileprivate static var globalEnvironment: EnvironmentProtocol?

    required init(networkSession: NetworkSessionProtocol) {
        self.networkSession = networkSession
        self.environment = RequestDispatcher.globalEnvironment! // Fix it later
    }
    
    private func currentEnvironment() -> EnvironmentProtocol? {
        return RequestDispatcher.globalEnvironment
    }
    
    class func setEnvironment(_ environment: EnvironmentProtocol) {
        RequestDispatcher.globalEnvironment = environment
    }
    
    func execute<T: Codable>(request: RequestProtocol, of type: T.Type, completion: @escaping (T) -> Void) {

        guard var urlRequest = request.urlRequest(with: environment) else {
            return
        }

        environment.headers?.forEach({ (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        })

        request.headers?.forEach({ (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        })
        
        var task: URLSessionTask?
        task = networkSession.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
            let jsonDecoder = JSONDecoder()
              do {
                     let ip = try jsonDecoder.decode(T.self, from: data!)
                     completion(ip)
               } catch {
                    print("an error occured")
               }
        })
        
        task?.resume()
    }

    private func verify(data: Any?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Any, Error> {
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
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

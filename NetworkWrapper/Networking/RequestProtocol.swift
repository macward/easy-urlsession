//
//  RequestProtocol.swift
//  NetworkWrapper
//
//  Created by Max Ward on 08/06/2021.
//

import Foundation

typealias ReaquestHeaders = [String: String]
typealias RequestParameters = [String : Any?]
typealias ProgressHandler = (Float) -> Void

protocol RequestProtocol {
    var baseUrl: String? { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: ReaquestHeaders? { get }
    var parameters: RequestParameters? { get }
}

extension RequestProtocol {
    
    public func urlRequest(with environment: EnvironmentProtocol?) -> URLRequest? {
        
        let stringUrl = urlSelector(environment: environment)
        
        guard let url = self.url(with: stringUrl) else {
            fatalError(RuntimeApiError.notValidUrlFormat.rawValue)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonBody

        return request
    }
    
    private func urlSelector(environment: EnvironmentProtocol?) -> String {
        
        if let environment = environment {
            return environment.baseURL
        } else if let url = self.baseUrl {
            return url
        } else {
            fatalError(RuntimeApiError.noUrlFound.rawValue)
        }
    }
        
    private func url(with baseURL: String) -> URL? {
    
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        
        urlComponents.path = urlComponents.path + path
        urlComponents.queryItems = queryItems

        return urlComponents.url
    }

    private var queryItems: [URLQueryItem]? {
        guard method == .get, let parameters = parameters else {
            return nil
        }
        return parameters.map { (key: String, value: Any?) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }

    // Returns the URLRequest body `Data`
    private var jsonBody: Data? {
        guard [.post, .put, .patch].contains(method), let parameters = parameters else {
            return nil
        }
        var jsonBody: Data?
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            return nil
        }
        return jsonBody
    }
}

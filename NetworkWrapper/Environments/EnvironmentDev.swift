//
//  EnvironmentDev.swift
//  NetworkWrapper
//
//  Created by Max Ward on 09/06/2021.
//

import Foundation

enum APIEnvironment: EnvironmentProtocol {
    /// The development environment.
    case development
    /// The production environment.
    case production

    /// The default HTTP request headers for the given environment.
    var headers: ReaquestHeaders? {
        switch self {
        case .development:
            return [
                "Content-Type" : "application/json",
                "Authorization" : "Bearer yourBearerToken"
            ]
        case .production:
            return [:]
        }
    }

    /// The base URL of the given environment.
    var baseURL: String {
        switch self {
        case .development:
            return "https://random-data-api.com/api"
        case .production:
            return "https://random-data-api.com/api"
        }
    }
}

//
//  APINetworkSession.swift
//  NetworkWrapper
//
//  Created by Max Ward on 09/06/2021.
//

import Foundation

class NetworkSession: NSObject, NetworkSessionProtocol{
    
    var session: URLSession!
    
    public override convenience init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 30
        sessionConfiguration.waitsForConnectivity = true
        self.init(configuration: sessionConfiguration)
    }

    public init(configuration: URLSessionConfiguration) {
        super.init()
        self.session = URLSession(configuration: configuration)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        return dataTask
    }
}

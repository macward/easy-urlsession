//
//  NetworkSessionProtocol.swift
//  NetworkWrapper
//
//  Created by Max Ward on 02/02/2022.
//

import Foundation

protocol NetworkSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?
}

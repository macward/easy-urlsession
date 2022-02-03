//
//  EnvironmentProtocol.swift
//  NetworkWrapper
//
//  Created by Max Ward on 02/02/2022.
//

import Foundation

protocol EnvironmentProtocol {
    var headers: ReaquestHeaders? { get }
    var baseURL: String { get }
}

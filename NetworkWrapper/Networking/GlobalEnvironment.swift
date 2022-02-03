//
//  GlobalEnvironment.swift
//  NetworkWrapper
//
//  Created by Max Ward on 02/02/2022.
//

import Foundation

class GlobalEnvironment {
    
    static let shared = GlobalEnvironment()
    
    fileprivate var environment: EnvironmentProtocol?
    
    func current() -> EnvironmentProtocol? {
        return environment
    }
    
    func setEnvironment(_ environment: EnvironmentProtocol) {
        RequestDispatcher.setEnvironment(environment)
    }
    
}

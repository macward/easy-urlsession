//
//  BooksEndpoint.swift
//  NetworkWrapper
//
//  Created by Max Ward on 09/06/2021.
//
import Foundation

/// Books endpoint
enum BooksEndpoint: RequestProtocol {
    
    /// Lists all the books.
    case index
    
    var baseUrl: String? {
        return "https://random-data-api.com/api"
//        return nil
    }
    
    var path: String {
        return "/bank/random_bank"
    }

    var method: RequestMethod {
        return .get
    }

    var headers: ReaquestHeaders? {
        return nil
    }

    var parameters: RequestParameters? {
        return nil
    }

    var progressHandler: ProgressHandler? {
        get { nil }
        set { }
    }
}

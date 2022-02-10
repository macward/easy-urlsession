//
//  RuntimeApiError.swift
//  RedditTopPosts
//
//  Created by Max Ward on 09/02/2022.
//

import Foundation

enum RuntimeApiError: String {
    case noUrlFound = "(error 101 - No url found)"
    case urlNotProvided = "error 102 - Url not provided"
    case notValidUrlFormat = "(error 103 - Not valid url format)"
}

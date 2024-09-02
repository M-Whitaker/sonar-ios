//
//  APIError.swift
//  SonariOS
//
//  Created by Matt Whitaker on 18/08/2024.
//

import Foundation

import HTTPTypes

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPResponse.Status)
    case unexpectedResponse
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: "Invalid URL"
        case let .httpCode(code): "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: "Unexpected response from the server"
        }
    }
}

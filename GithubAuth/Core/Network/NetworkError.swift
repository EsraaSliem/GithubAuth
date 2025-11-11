//
//  NetworkError.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 10/11/2025.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case badURL
    case invalidResponse
    case unauthorized
    case forbidden
    case rateLimited
    case serverError(statusCode: Int)
    case decodingError(Error)
    case transportError(Error)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL is malformed."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        case .forbidden:
            return "You do not have permission to access this resource."
        case .rateLimited:
            return "You have hit GitHub's rate limit. Please try again later."
        case .serverError(let statusCode):
            return "Server returned an error (code \(statusCode))."
        case .decodingError:
            return "Failed to decode the server response."
        case .transportError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}

extension NetworkError {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL),
             (.invalidResponse, .invalidResponse),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.rateLimited, .rateLimited),
             (.unknownError, .unknownError):
            return true
        case let (.serverError(code1), .serverError(code2)):
            return code1 == code2
        case (.decodingError, .decodingError),
             (.transportError, .transportError):
            return true
        default:
            return false
        }
    }
}

//
//  APIEndpoint.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 10/11/2025.
//

import Foundation

public enum AuthenticationEndpoint {
    private static let baseURL = "https://github.com/login/oauth"

    case authURL(clientID: String, redirectURI: String, scope: String)
    case getAccessToken(code: String, clientID: String, clientSecret: String, redirectURI: String)

    public var url: URL? {
        switch self {
        case .authURL(let clientID, let redirectURI, let scope):
            var components = URLComponents(string: "\(Self.baseURL)/authorize")
            components?.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "scope", value: scope),
                URLQueryItem(name: "redirect_uri", value: redirectURI)
            ]
            return components?.url
        case .getAccessToken:
            return URL(string: "\(Self.baseURL)/access_token")
        }
    }

    public func asURLRequest() throws -> URLRequest {
        switch self {
        case .authURL:
            throw NetworkError.badURL
        case .getAccessToken(let code, let clientID, let clientSecret, let redirectURI):
            guard let requestURL = url else {
                throw NetworkError.badURL
            }

            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")

            let queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "client_secret", value: clientSecret),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: redirectURI)
            ]

            var components = URLComponents()
            components.queryItems = queryItems
            request.httpBody = components.query?.data(using: .utf8)
            return request
        }
    }
}

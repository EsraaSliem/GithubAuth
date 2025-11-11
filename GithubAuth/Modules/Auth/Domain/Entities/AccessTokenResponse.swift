//
//  AccessTokenResponse.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Foundation

public struct AccessTokenResponse: Codable {
    public let accessToken: String
    public let scope: String
    public let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken
        case scope
        case tokenType
    }
}

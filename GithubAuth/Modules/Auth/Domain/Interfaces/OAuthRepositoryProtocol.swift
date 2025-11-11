//
//  OAuthRepositoryProtocol.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine

protocol OAuthRepositoryProtocol {
    func exchangeCodeForToken(code: String) -> AnyPublisher<AccessTokenResponse, NetworkError>
}

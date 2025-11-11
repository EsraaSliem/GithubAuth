//
//  OAuthServiceProtocol.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine

protocol OAuthServiceProtocol {
    func startSignIn() -> AnyPublisher<String, NetworkError>
}

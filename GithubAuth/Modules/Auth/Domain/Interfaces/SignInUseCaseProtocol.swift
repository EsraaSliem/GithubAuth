//
//  SignInUseCaseProtocol.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine

protocol SignInUseCaseProtocol {
    func execute() -> AnyPublisher<String, NetworkError>
}


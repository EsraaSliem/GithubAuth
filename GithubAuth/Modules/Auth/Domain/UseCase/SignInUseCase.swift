//
//  SignInUseCase.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine

final class SignInUseCase: SignInUseCaseProtocol {
    private let oauthService: OAuthServiceProtocol
    private let secureStorage: SecureStorage

    init(
        oauthService: OAuthServiceProtocol,
        secureStorage: SecureStorage,
    ) {
        self.oauthService = oauthService
        self.secureStorage = secureStorage
    }

    func execute() -> AnyPublisher<String, NetworkError> {
        oauthService.startSignIn()
            .handleEvents(receiveOutput: { [weak self] token in
                guard let self else { return }
                self.secureStorage.save(token, for: GitHubConfiguration.storageKey)
            })
            .eraseToAnyPublisher()
    }
}

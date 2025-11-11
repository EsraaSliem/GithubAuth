//
//  LoadStoredTokenUseCase.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Foundation

protocol LoadStoredTokenUseCaseProtocol {
    func execute() -> String?
}

final class LoadStoredTokenUseCase: LoadStoredTokenUseCaseProtocol {
    private let secureStorage: SecureStorage
    private let storageKey: String = GitHubConfiguration.storageKey

    init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }

    func execute() -> String? {
        secureStorage.get(for: storageKey)
    }
}


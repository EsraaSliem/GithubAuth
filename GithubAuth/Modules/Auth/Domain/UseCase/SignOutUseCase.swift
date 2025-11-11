//
//  SignOutUseCase.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Foundation

protocol SignOutUseCaseProtocol {
    func execute()
}

final class SignOutUseCase: SignOutUseCaseProtocol {
    private let secureStorage: SecureStorage
    private let storageKey: String = GitHubConfiguration.storageKey

    init(secureStorage: SecureStorage) {
        self.secureStorage = secureStorage
    }

    func execute() {
        secureStorage.delete(for: storageKey)
    }
}


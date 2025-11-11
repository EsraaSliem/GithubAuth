//
//  OAuthViewModel.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine
import SwiftUI


final class AuthViewModel: ObservableObject {
    enum ViewState: Equatable {
        case signedOut
        case signingIn
        case signedIn
    }

    @Published private(set) var state: ViewState
    @Published private(set) var tokenPreview: String?
    @Published private(set) var token: String?
    @Published var errorMessage: String?

    private let signInUseCase: SignInUseCaseProtocol
    private let loadStoredTokenUseCase: LoadStoredTokenUseCaseProtocol
    private let signOutUseCase: SignOutUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        signInUseCase: SignInUseCaseProtocol,
        loadStoredTokenUseCase: LoadStoredTokenUseCaseProtocol,
        signOutUseCase: SignOutUseCaseProtocol
    ) {
        self.signInUseCase = signInUseCase
        self.loadStoredTokenUseCase = loadStoredTokenUseCase
        self.signOutUseCase = signOutUseCase

        if let storedToken = loadStoredTokenUseCase.execute() {
            token = storedToken
            tokenPreview = Self.makePreview(from: storedToken)
            state = .signedIn
        } else {
            token = nil
            tokenPreview = nil
            state = .signedOut
        }
    }

    func signIn() {
        guard state != .signingIn else { return }

        errorMessage = nil
        state = .signingIn

        signInUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case let .failure(error) = completion {
                    self.handle(error: error)
                }
            } receiveValue: { [weak self] token in
                guard let self else { return }
                self.token = token
                self.tokenPreview = Self.makePreview(from: token)
                self.state = .signedIn
            }
            .store(in: &cancellables)
    }

    func signOut() {
        signOutUseCase.execute()
        token = nil
        tokenPreview = nil
        state = .signedOut
        errorMessage = nil
    }

    private func handle(error: NetworkError) {
        token = nil
        errorMessage = error.errorDescription ?? "Something went wrong."
        state = .signedOut
    }

    private static func makePreview(from token: String) -> String {
        let prefix = token.prefix(8)
        return "\(prefix)…"
    }
}

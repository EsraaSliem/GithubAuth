//
//  UseCaseTests.swift
//  GithubAuthTests
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine
import Foundation
import Testing
@testable import GithubAuth

struct SignInUseCaseTests {
    @Test func signInStoresTokenOnSuccess() async throws {
        let expectedToken = "token-123"
        let oauthService = MockOAuthService(result: .success(expectedToken))
        let secureStorage = MockSecureStorage()
        let useCase = SignInUseCase(oauthService: oauthService, secureStorage: secureStorage)

        let token = try await useCase.execute().asyncSingle()

        #expect(token == expectedToken)
        #expect(secureStorage.store[secureStorage.storageKey] == expectedToken)
    }

    @Test func signInPropagatesFailure() async {
        let oauthService = MockOAuthService(result: .failure(.unauthorized))
        let secureStorage = MockSecureStorage()
        let useCase = SignInUseCase(oauthService: oauthService, secureStorage: secureStorage)

        do {
            _ = try await useCase.execute().asyncSingle()
            Issue.record("Expected execute() to throw")
        } catch let error as NetworkError {
            #expect(error == .unauthorized)
            #expect(secureStorage.store.isEmpty)
        } catch {
            Issue.record("Unexpected error \(error)")
        }
    }
}

struct SecureStorageUseCasesTests {
    @Test func loadStoredTokenReturnsPersistedValue() {
        let secureStorage = MockSecureStorage(initial: ["github_access_token": "persisted"])
        let useCase = LoadStoredTokenUseCase(secureStorage: secureStorage)

        let token = useCase.execute()

        #expect(token == "persisted")
    }

    @Test func signOutDeletesStoredToken() {
        let secureStorage = MockSecureStorage(initial: ["github_access_token": "persisted"])
        let useCase = SignOutUseCase(secureStorage: secureStorage)

        useCase.execute()

        #expect(secureStorage.store["github_access_token"] == nil)
    }
}



private extension Publisher {
    func asyncSingle() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?

            cancellable = self.sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
                cancellable?.cancel()
            } receiveValue: { value in
                continuation.resume(returning: value)
                cancellable?.cancel()
            }
        }
    }
}

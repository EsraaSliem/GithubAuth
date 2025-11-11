//
//  MockOAuthService.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine
@testable import GithubAuth

 final class MockOAuthService: OAuthServiceProtocol {
    private let result: Result<String, NetworkError>

    init(result: Result<String, NetworkError>) {
        self.result = result
    }

    func startSignIn() -> AnyPublisher<String, NetworkError> {
        result.asPublisher()
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


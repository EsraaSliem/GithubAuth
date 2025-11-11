//
//  OAuthService.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import AuthenticationServices
import Combine
import UIKit

final class OAuthService: NSObject, OAuthServiceProtocol, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
                   .compactMap { $0 as? UIWindowScene }
                   .flatMap { $0.windows }
                   .first { $0.isKeyWindow } ?? UIWindow()
    }
    
    private let clientID: String
    private let redirectURI: String
    private let callbackScheme: String
    private let scope: String
    private let repository: OAuthRepositoryProtocol
    private var session: ASWebAuthenticationSession?

    init(
        clientID: String,
        redirectURI: String,
        callbackScheme: String,
        scope: String,
        repository: OAuthRepositoryProtocol
    ) {
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.callbackScheme = callbackScheme
        self.scope = scope
        self.repository = repository
    }

    func startSignIn() -> AnyPublisher<String, NetworkError> {
        do {
            let authURL = try determineAuthURL()
            return presentAuthentication(for: authURL)
                .flatMap { [weak self] code -> AnyPublisher<String, NetworkError> in
                    guard let self else {
                        return Fail(error: NetworkError.unknownError).eraseToAnyPublisher()
                    }
                    return self.repository
                        .exchangeCodeForToken(code: code)
                        .map(\.accessToken)
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        } catch {
            let mappedError = error as? NetworkError ?? .badURL
            return Fail(error: mappedError).eraseToAnyPublisher()
        }
    }

    private func determineAuthURL() throws -> URL {
        guard let url = AuthenticationEndpoint
            .authURL(clientID: clientID, redirectURI: redirectURI, scope: scope)
            .url else {
            throw NetworkError.badURL
        }
        return url
    }

    private func presentAuthentication(for url: URL) -> AnyPublisher<String, NetworkError> {
        Future<String, NetworkError> { [weak self] promise in
            guard let self else {
                promise(.failure(.unknownError))
                return
            }

            DispatchQueue.main.async {
                self.session = ASWebAuthenticationSession(
                    url: url,
                    callbackURLScheme: self.callbackScheme
                ) { callbackURL, error in
                    if let error {
                        promise(.failure(.transportError(error)))
                        return
                    }

                    guard
                        let callbackURL,
                        let code = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?
                            .queryItems?
                            .first(where: { $0.name == "code" })?
                            .value
                    else {
                        promise(.failure(.badURL))
                        return
                    }

                    promise(.success(code))
                }

                self.session?.presentationContextProvider = self
                self.session?.prefersEphemeralWebBrowserSession = false

                if self.session?.start() == false {
                    promise(.failure(.unknownError))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    @MainActor
    private static func resolvePresentationAnchor() -> ASPresentationAnchor {
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return window
        }

        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first {
            return window
        }

        let fallback = UIWindow(frame: UIScreen.main.bounds)
        fallback.makeKeyAndVisible()
        return fallback
    }
}

private final class PresentationProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    private let anchor: ASPresentationAnchor

    init(anchor: ASPresentationAnchor) {
        self.anchor = anchor
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        anchor
    }
}

//
//  OAuthRepository.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//
import Combine
import Foundation

final class OAuthRepository: OAuthRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let clientID: String
    private let clientSecret: String
    private let redirectURI: String

    init(networkService: NetworkServiceProtocol, clientID: String, clientSecret: String, redirectURI: String) {
        self.networkService = networkService
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
    func exchangeCodeForToken(code: String) -> AnyPublisher<AccessTokenResponse, NetworkError> {
        do {
            let endpoint = AuthenticationEndpoint.getAccessToken(
                code: code,
                clientID: clientID,
                clientSecret: clientSecret,
                redirectURI: redirectURI
            )
            let request = try endpoint.asURLRequest()

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            return networkService
                .request(request, decoder: decoder)
        } catch {
            let mappedError = error as? NetworkError ?? .badURL
            return Fail(error: mappedError).eraseToAnyPublisher()
        }
    }
}

//
//  GitHubRepositoriesRepository.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Combine
import Foundation

final class GitHubRepositoriesRepository: RepositoriesRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchRepositories(page: Int, perPage: Int, token: String) -> AnyPublisher<[Repository], NetworkError> {
        do {
            let request = try GitHubReposAPIEndpoint
                .currentUserRepos(page: page, perPage: perPage)
                .makeRequest(token: token)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            return networkService
                .request<[Repository]>(request, decoder: decoder)
                .eraseToAnyPublisher()
        } catch let networkError as NetworkError {
            return Fail(error: networkError).eraseToAnyPublisher()
        } catch {
            return Fail(error: .unknownError).eraseToAnyPublisher()
        }
    }
}


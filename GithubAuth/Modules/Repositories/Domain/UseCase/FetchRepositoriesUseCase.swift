//
//  FetchRepositoriesUseCase.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Combine

protocol FetchRepositoriesUseCaseProtocol {
    func execute(page: Int, perPage: Int, token: String) -> AnyPublisher<[Repository], NetworkError>
}

final class FetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol {
    private let repository: RepositoriesRepositoryProtocol

    init(repository: RepositoriesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int, perPage: Int, token: String) -> AnyPublisher<[Repository], NetworkError> {
        repository.fetchRepositories(page: page, perPage: perPage, token: token)
    }
}


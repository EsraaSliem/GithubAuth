//
//  RepositoriesRepositoryProtocol.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Combine

protocol RepositoriesRepositoryProtocol {
    func fetchRepositories(page: Int, perPage: Int, token: String) -> AnyPublisher<[Repository], NetworkError>
}


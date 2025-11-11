//
//  FetchBranchesUseCase.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Combine

protocol FetchBranchesUseCaseProtocol {
    func execute(owner: String, repo: String, page: Int, perPage: Int, token: String) -> AnyPublisher<[Branch], NetworkError>
}

final class FetchBranchesUseCase: FetchBranchesUseCaseProtocol {
    private let repository: BranchesRepositoryProtocol

    init(repository: BranchesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(owner: String, repo: String, page: Int, perPage: Int, token: String) -> AnyPublisher<[Branch], NetworkError> {
        repository.fetchBranches(owner: owner, repo: repo, page: page, perPage: perPage, token: token)
    }
}


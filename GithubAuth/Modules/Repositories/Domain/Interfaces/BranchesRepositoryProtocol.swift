//
//  BranchesRepositoryProtocol.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Combine

protocol BranchesRepositoryProtocol {
    func fetchBranches(owner: String, repo: String, page: Int, perPage: Int, token: String) -> AnyPublisher<[Branch], NetworkError>
}


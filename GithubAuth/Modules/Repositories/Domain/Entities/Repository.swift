//
//  RepositoryDTO.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Foundation

struct Repository: Decodable, Identifiable {
    struct OwnerDTO: Decodable {
        let login: String
    }

    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let owner: OwnerDTO
    let isPrivate: Bool
    let stargazersCount: Int
    let language: String?
    let updatedAt: Date
    let `default`: String?
    let defaultBranch: String
    let visibility: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName
        case description
        case owner
        case isPrivate = "private"
        case stargazersCount
        case language
        case updatedAt
        case visibility
        case defaultBranch
        case `default` = "default"
    }
}



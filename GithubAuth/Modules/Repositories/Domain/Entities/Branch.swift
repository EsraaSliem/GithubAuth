//
//  BranchResponse.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Foundation

struct Branch: Decodable {
    struct Commit: Decodable {
        let sha: String
    }

    let name: String
    let commit: Commit
    let isProtected: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case commit
        case isProtected = "protected"
    }
}

//
//  GitHubAPIEndpoint.swift
//  GithubAuth
//
//  Created by Esraa Sliem  on 11/11/2025.
//

import Foundation

enum GitHubReposAPIEndpoint {
    private static let baseURL = URL(string: "https://api.github.com")!

    case currentUserRepos(page: Int, perPage: Int)
    case repositoryBranches(owner: String, repo: String, page: Int, perPage: Int)

    func makeRequest(token: String) throws -> URLRequest {
        var url: URL

        switch self {
        case let .currentUserRepos(page, perPage):
            url = Self.baseURL
                .appendingPathComponent("user")
                .appendingPathComponent("repos")
            url = url
                .appending(queryItems: [
                    URLQueryItem(name: "per_page", value: "\(perPage)"),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "sort", value: "updated"),
                    URLQueryItem(name: "direction", value: "desc")
                ])
        case let .repositoryBranches(owner, repo, page, perPage):
            url = Self.baseURL
                .appendingPathComponent("repos")
                .appendingPathComponent(owner)
                .appendingPathComponent(repo)
                .appendingPathComponent("branches")
            url = url
                .appending(queryItems: [
                    URLQueryItem(name: "per_page", value: "\(perPage)"),
                    URLQueryItem(name: "page", value: "\(page)")
                ])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        return request
    }
}

private extension URL {
    func appending(queryItems: [URLQueryItem]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        components.queryItems = (components.queryItems ?? []) + queryItems
        return components.url ?? self
    }
}


//
//  RepositoriesViewModel.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine
import Foundation

@MainActor
final class RepositoriesViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    enum VisibilityFilter: String, CaseIterable, Identifiable {
        case all
        case `public`
        case `private`

        var id: String { rawValue }

        var title: String {
            switch self {
            case .all:
                return "All"
            case .public:
                return "Public"
            case .private:
                return "Private"
            }
        }
    }

    @Published private(set) var repositories: [Repository] = []
    @Published private(set) var state: ViewState = .idle
    @Published var searchQuery: String = ""
    @Published var visibilityFilter: VisibilityFilter = .all

    private let fetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentToken: String?
    private let pageSize: Int

    init(
        fetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol,
        pageSize: Int = 30
    ) {
        self.fetchRepositoriesUseCase = fetchRepositoriesUseCase
        self.pageSize = pageSize
    }

    func loadRepositories(with token: String) {
        guard state != .loading else { return }
        guard currentToken != token || repositories.isEmpty else { return }

        currentToken = token
        state = .loading

        fetchRepositoriesUseCase
            .execute(page: 1, perPage: pageSize, token: token)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case let .failure(error) = completion {
                    self.state = .failed(error.errorDescription ?? "Unable to load repositories.")
                }
            } receiveValue: { [weak self] repositories in
                guard let self else { return }
                self.repositories = repositories
                self.state = .loaded
            }
            .store(in: &cancellables)
    }

    var filteredRepositories: [Repository] {
        repositories
            .filter { repository in
                matchesVisibility(repository: repository) && matchesSearchQuery(repository: repository)
            }
    }

    func reset() {
        repositories = []
        state = .idle
        currentToken = nil
        cancellables.removeAll()
    }

    private func matchesVisibility(repository: Repository) -> Bool {
        switch visibilityFilter {
        case .all:
            return true
        case .public:
            return !repository.isPrivate
        case .private:
            return repository.isPrivate
        }
    }

    private func matchesSearchQuery(repository: Repository) -> Bool {
        guard !searchQuery.isEmpty else { return true }
        let normalizedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !normalizedQuery.isEmpty else { return true }

        return repository.fullName.lowercased().contains(normalizedQuery)
            || (repository.description?.lowercased().contains(normalizedQuery) ?? false)
    }
}


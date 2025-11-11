//
//  RepositoriesView.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

import SwiftUI

struct RepositoriesView: View {
    @ObservedObject var viewModel: RepositoriesViewModel
    let token: String
    let onSignOut: () -> Void

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Repositories")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Sign Out", role: .destructive) {
                            viewModel.reset()
                            onSignOut()
                        }
                    }
                }
        }
        .onAppear {
            viewModel.loadRepositories(with: token)
        }
        .onChange(of: token) { newToken in
            viewModel.loadRepositories(with: newToken)
        }
        .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search repositories")
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading where viewModel.repositories.isEmpty:
            ProgressView("Loading repositories…")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        case .failed(let message):
            VStack(spacing: 12) {
                Text("We couldn't fetch your repositories.")
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button {
                    viewModel.loadRepositories(with: token)
                } label: {
                    Text("Retry")
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
        default:
            VStack(spacing: 12) {
                Picker("Visibility", selection: $viewModel.visibilityFilter) {
                    ForEach(RepositoriesViewModel.VisibilityFilter.allCases) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                let repositories = viewModel.filteredRepositories

                if repositories.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No repositories")
                            .font(.headline)
                        Text("Try adjusting your search or filters.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding()
                } else {
                    List(repositories) { repository in
                        RepositoryRow(repository: repository)
                    }
                    .listStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct RepositoryRow: View {
    let repository: Repository

    private var subtitle: String {
        var components: [String] = []
        if let language = repository.language {
            components.append(language)
        }
        components.append(repository.visibility.capitalized)
        return components.joined(separator: " • ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(repository.fullName)
                .font(.headline)
            if let description = repository.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

#Preview {
    RepositoriesView(
        viewModel: RepositoriesViewModel(
            fetchRepositoriesUseCase: FetchRepositoriesUseCase(
                repository: GitHubRepositoriesRepository(networkService: NetworkService())
            )
        ),
        token: "preview-token",
        onSignOut: {}
    )
}


//
//  GithubAuthApp.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 10/11/2025.
//

import SwiftUI

@main
struct GithubAuthApp: App {
    @StateObject private var authViewModel: AuthViewModel
    @StateObject private var repositoriesViewModel: RepositoriesViewModel

    init() {
        let networkService = NetworkService()
        let secureStorage = KeyChainManager()

        let oauthRepository = OAuthRepository(
            networkService: networkService,
            clientID: GitHubConfiguration.clientID,
            clientSecret: GitHubConfiguration.clientSecret,
            redirectURI: GitHubConfiguration.redirectURI
        )

        let oauthService = OAuthService(
            clientID: GitHubConfiguration.clientID,
            redirectURI: GitHubConfiguration.redirectURI,
            callbackScheme: GitHubConfiguration.callbackScheme,
            scope: GitHubConfiguration.scope,
            repository: oauthRepository
        )

        let signInUseCase = SignInUseCase(
            oauthService: oauthService,
            secureStorage: secureStorage
        )

        let loadStoredTokenUseCase = LoadStoredTokenUseCase(secureStorage: secureStorage)
        let signOutUseCase = SignOutUseCase(secureStorage: secureStorage)
        let repositoriesRepository = GitHubRepositoriesRepository(networkService: networkService)
        let fetchRepositoriesUseCase = FetchRepositoriesUseCase(repository: repositoriesRepository)

        _authViewModel = StateObject(
            wrappedValue: AuthViewModel(
                signInUseCase: signInUseCase,
                loadStoredTokenUseCase: loadStoredTokenUseCase,
                signOutUseCase: signOutUseCase
            )
        )
        _repositoriesViewModel = StateObject(
            wrappedValue: RepositoriesViewModel(
                fetchRepositoriesUseCase: fetchRepositoriesUseCase
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if case .signedIn = authViewModel.state, let token = authViewModel.token {
                    RepositoriesView(
                        viewModel: repositoriesViewModel,
                        token: token
                    ) {
                        repositoriesViewModel.reset()
                        authViewModel.signOut()
                    }
                } else {
                    LoginView(viewModel: authViewModel)
                        .onAppear {
                            repositoriesViewModel.reset()
                        }
                }
            }
        }
    }
}


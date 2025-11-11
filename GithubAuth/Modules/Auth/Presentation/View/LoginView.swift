//
//  LoginView.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 24) {
            switch viewModel.state {
            case .signedOut:
                signInButton
            case .signingIn:
                ProgressView("Signing in…")
                    .progressViewStyle(.circular)
            case .signedIn:
                EmptyView()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
    }

    private var signInButton: some View {
        Button {
            viewModel.signIn()
        } label: {
            Text("Sign In with GitHub")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

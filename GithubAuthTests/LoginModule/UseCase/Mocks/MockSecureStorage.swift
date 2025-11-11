//
//  MockSecureStorage.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//
@testable import GithubAuth

final class MockSecureStorage: SecureStorage {
    var store: [String: String]
    let storageKey: String

    init(initial: [String: String] = [:], storageKey: String = "github_access_token") {
        self.store = initial
        self.storageKey = storageKey
    }

    func save(_ value: String, for key: String) {
        store[key] = value
    }

    func get(for key: String) -> String? {
        store[key]
    }

    func delete(for key: String) {
        store.removeValue(forKey: key)
    }
}

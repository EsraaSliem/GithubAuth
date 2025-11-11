//
//  SecureStorage.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 11/11/2025.
//

protocol SecureStorage {
    func save(_ value: String, for key: String)
    func get(for key: String) -> String?
    func delete(for key: String)
}

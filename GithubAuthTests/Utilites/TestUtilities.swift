//
//  TestUtilities.swift
//  GithubAuthTests
//
//  Created by Esraa Sliem on 11/11/2025.
//

import Combine
import Foundation

extension Result where Failure: Error {
    func asPublisher() -> AnyPublisher<Success, Failure> {
        switch self {
        case .success(let value):
            return Just(value)
                .setFailureType(to: Failure.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}


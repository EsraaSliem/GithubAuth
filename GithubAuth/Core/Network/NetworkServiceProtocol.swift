//
//  NetworkServiceProtocol.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 10/11/2025.
//
import Foundation
import Combine

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ request: URLRequest,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, NetworkError>
}

extension NetworkServiceProtocol {
    func request<T: Decodable>(
        _ request: URLRequest
    ) -> AnyPublisher<T, NetworkError> {
        self.request(request, decoder: JSONDecoder())
    }
}


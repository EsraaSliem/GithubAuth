//
//  NetworkService.swift
//  GithubAuth
//
//  Created by Esraa Sliem on 10/11/2025.
//

import Foundation
import Combine

final class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func request<T: Decodable>(
        _ request: URLRequest,
        decoder: JSONDecoder
    ) -> AnyPublisher<T, NetworkError> {
        urlSession
            .dataTaskPublisher(for: request)
            .tryMap { [weak self] data, response in
                guard let self else {
                    throw NetworkError.unknownError
                }
                return try self.validateResponse(data: data, response: response, request: request)
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { [weak self] error in
                self?.mapError(error, for: request) ?? .unknownError
            }
            .eraseToAnyPublisher()
    }
}

private extension NetworkService {
    func validateResponse(
        data: Data,
        response: URLResponse,
        request: URLRequest
    ) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
                
        guard (200...299).contains(httpResponse.statusCode) else {
            throw statusCodeError(httpResponse.statusCode)
        }
        
        return data
    }
    
    func mapError(_ error: Error, for request: URLRequest) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        
        if let decodingError = error as? DecodingError {
            return .decodingError(decodingError)
        }
        
        if let urlError = error as? URLError {
            return .transportError(urlError)
        }
        
        return .unknownError
    }
    
    func statusCodeError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 429:
            return .rateLimited
        default:
            return .serverError(statusCode: statusCode)
        }
    }
}

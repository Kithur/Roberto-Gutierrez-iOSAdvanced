//
//  APIService.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 18/04/23.
//

import Combine
import Foundation

enum APIError: Error {
    case apiError(_ description: String)
    case invalidResponse
    case serializationError
    case invalidEndpoint
    
    var localizedDescription: String {
        switch self {
        case .invalidEndpoint: return "Invalid endpoint"
        case .apiError: return "Failed to fetch data"
        case .invalidResponse: return "Invalid response"
        case .serializationError: return "Failed to decode data"
        }
    }
}

protocol APIService {
    func fetch<T: Decodable>(from pokemonRequest: PokemonRequest,
                             decodedType: T.Type) -> AnyPublisher<T, APIError>
}

final class ServiceManager: APIService {
    private var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetch<T: Decodable>(from pokemonRequest: PokemonRequest,
                             decodedType: T.Type) -> AnyPublisher<T, APIError> {
        guard let finalURL: URL = pokemonRequest.getFinalURL() else {
            return Fail(error: APIError.invalidEndpoint).eraseToAnyPublisher()
        }
        return session
            .dataTaskPublisher(for: finalURL)
            .tryMap { data, response -> T in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIError.invalidResponse
                }
                do {
                    let modelDecoded: T = try Util.jsonDecoder.decode(decodedType, from: data)
                    return modelDecoded
                } catch {
                    throw APIError.serializationError
                }
            }
            .mapError { error in
                APIError.apiError(error.localizedDescription)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

//
//  PokemonDetailRepository.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import Combine

protocol PokemonDetailRepositoryProtocol {
    func fetchPokemon(id: String) -> AnyPublisher<RawPokemon,Error>
}

final class PokemonDetailRepository: PokemonDetailRepositoryProtocol {
    private let serviceManager: APIService

    init(serviceManager: APIService) {
        self.serviceManager = serviceManager
    }

    func fetchPokemon(id: String) -> AnyPublisher<RawPokemon, Error> {
        serviceManager
            .fetch(from: .id(id),
                   decodedType: RawPokemon.self)
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
}

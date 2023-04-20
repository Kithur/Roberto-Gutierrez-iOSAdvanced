//
//  FetchPokemonUseCase.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import Foundation
import Combine

protocol FetchPokemonUseCaseProtocol {
    func execute(id: String) -> AnyPublisher<PokemonDetail, Error>
}

final class FetchPokemonUseCase: FetchPokemonUseCaseProtocol {
    private let repository: PokemonDetailRepositoryProtocol

    init(repository: PokemonDetailRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) -> AnyPublisher<PokemonDetail, Error> {
        repository
            .fetchPokemon(id: id)
            .map({ PokemonDetail(rawPokemon: $0) })
            .eraseToAnyPublisher()
    }
}

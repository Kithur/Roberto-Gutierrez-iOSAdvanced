//
//  WriteToDatabaseUseCase.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 20/04/23.
//

import Foundation
import Combine

protocol WriteToDatabaseUseCaseProtocol {
    func execute(pokemonList: [Pokemon])
}

final class WriteToDatabaseUseCase: WriteToDatabaseUseCaseProtocol {
    private let repository: HomeViewRepositoryProtocol

    init(repository: HomeViewRepositoryProtocol) {
        self.repository = repository
    }

    func execute(pokemonList: [Pokemon]) {
        let pokemonDatabaseList: [PokemonDatabaseEntity] = pokemonList.compactMap { pokemon in
            guard let value = getDictionary(pokemon: pokemon) else { return nil }
            return PokemonDatabaseEntity(value: value)
        }
        repository.writeToDatabase(pokemonList: pokemonDatabaseList)
    }

    private func getDictionary(pokemon: Pokemon) -> Any? {
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(pokemon) else {
            return nil
        }
        let dictionary = try? JSONSerialization.jsonObject(with: jsonData,
                                                           options: [])
        return dictionary
    }
}

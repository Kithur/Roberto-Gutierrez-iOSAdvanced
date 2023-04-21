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
            guard let value = Util.getDictionary(object: pokemon) else { return nil }
            return PokemonDatabaseEntity(value: value)
        }
        repository.writeToDatabase(pokemonList: pokemonDatabaseList)
    }
}

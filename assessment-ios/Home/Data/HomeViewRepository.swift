//
//  HomeViewRepository.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import Combine
import Foundation

protocol HomeViewRepositoryProtocol {
    func fetchPokemonList(listCount: Int) -> AnyPublisher<[Pokemon], Error>
    func writeToDatabase(pokemonList: [PokemonDatabaseEntity])
}

final class HomeViewRepository: HomeViewRepositoryProtocol {
    private let serviceManager: APIService
    let databaseManager: DatabaseManagerProtocol
    init(serviceManager: APIService, databaseManager: DatabaseManagerProtocol) {
        self.serviceManager = serviceManager
        self.databaseManager = databaseManager
    }

    func fetchPokemonList(listCount: Int) -> AnyPublisher<[Pokemon], Error> {
        if NetworkMonitor.shared.isConnected {
            return fetchPokemonListFromRemote(listCount: listCount)
        } else {
            return fetchPokemonListFromLocal()
        }
    }

    func fetchPokemonListFromRemote(listCount: Int) -> AnyPublisher<[Pokemon], Error> {
        serviceManager
            .fetch(from: .pagination(String(listCount)),
                   decodedType: PokemonList.self)
            .map({ $0.results })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }

    func fetchPokemonListFromLocal() -> AnyPublisher<[Pokemon], Error> {
        databaseManager
            .read(decodedType: PokemonDatabaseEntity.self)
            .map({ result in
                return result.map({ Pokemon(pokemonDatabaseEntity: $0) })
            })
            .eraseToAnyPublisher()
    }

    func writeToDatabase(pokemonList: [PokemonDatabaseEntity]) {
        pokemonList.forEach { pokemon in
            databaseManager.create(pokemon)
        }
    }

}

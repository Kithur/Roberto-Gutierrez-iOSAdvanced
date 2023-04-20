//
//  HomeEntities.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import Foundation
// MARK: - PokemonList
struct PokemonList: Codable {
    let results: [Pokemon]
}

// MARK: - Pokemon
struct Pokemon: Codable {
    let name: String
    let url: String
}

extension Pokemon {
    init(pokemonDatabaseEntity: PokemonDatabaseEntity) {
        name = pokemonDatabaseEntity.name
        url = pokemonDatabaseEntity.url
    }
}

//
//  PokemonDetailEntities.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import Foundation
// MARK: - PokemonDetail
struct PokemonDetail {
    let name: String
    let id: String
    let abilities: [String]
    let height: String
    let weight: String
    let types: [String]
    let stats: [String]
}

extension PokemonDetail {
    init(rawPokemon: RawPokemon) {
        name = rawPokemon.name
        id = String(rawPokemon.id)
        abilities = rawPokemon.abilities.map({ $0.ability.name })
        height = String(rawPokemon.height)
        weight = String(rawPokemon.weight)
        types = rawPokemon.types.map({ $0.type.name })
        stats = rawPokemon.stats.map({ "\($0.stat.name): \(String($0.baseStat))"})
    }
}

extension PokemonDetail {
    var printableAbilities: String {
        abilities.joined(separator: ", ")
    }

    var printableTypes: String {
        types.joined(separator: "/")
    }

    var officialArtworkURL: URL? {
        PokemonRequest.officialArtwork(from: id)
    }
}

// MARK: - RawPokemon
struct RawPokemon: Codable {
    let abilities: [Ability]
    let height: Int
    let id: Int
    let name: String
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int
}

extension RawPokemon {
    var printAbilities: String {
        let hola = abilities.map{ $0.ability.name }
        return hola.joined(separator: ", ")
    }
}

// MARK: - Ability
struct Ability: Codable {
    let ability: NameContainer
}

// MARK: - Species
struct NameContainer: Codable {
    let name: String
}

// MARK: - Stat
struct Stat: Codable {
    let baseStat: Int
    let stat: NameContainer
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: NameContainer
}

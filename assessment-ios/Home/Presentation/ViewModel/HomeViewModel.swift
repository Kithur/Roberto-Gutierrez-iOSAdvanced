//
//  HomeViewModel.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 18/04/23.
//

import Foundation
import Combine
// MARK: - Welcome
struct PokemonList: Codable {
    let results: [Pokemon]
}

// MARK: - Result
struct Pokemon: Codable {
    let name: String
    let url: String
}

final class HomeViewModel: ObservableObject {
    @Published var pokemonArray = [Pokemon]()
    let serviceManager: APIService = ServiceManager()
    var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func fetchPokemonList() {
        serviceManager
            .fetch(from: .pagination(String(pokemonArray.count)), decodedType: PokemonList.self)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure:
                    break
                default:
                    break
                }
            }, receiveValue: { [weak self] pokemonList  in
                self?.pokemonArray.append(contentsOf: pokemonList.results)
            }).store(in: &bag)
    }
}

//
//  PokemonDetailViewModel.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import Foundation
import Combine

protocol PokemonDetailViewModelProtocol: ObservableObject {
    var pokemon: PokemonDetail? { get set }
    var state: DetailViewState { get set }
    func fetchPokemon()
}

enum DetailViewState {
    case loading
    case success
    case failure
}

enum PokemonId {
    case byName(name: String)
    case byNumber(id: Int)

    var pokemonId: String {
        switch self {
        case .byName(name: let name):
            return name.lowercased()
        case .byNumber(id: let id):
            return String(id + 1)
        }
    }
}

final class PokemonDetailViewModel: PokemonDetailViewModelProtocol {
    var pokemon: PokemonDetail?
    @Published var state: DetailViewState = .loading
    private let id: String
    private let useCase: FetchPokemonUseCaseProtocol
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()

    init(id: PokemonId, useCase: FetchPokemonUseCaseProtocol) {
        self.id = id.pokemonId
        self.useCase = useCase
    }

    func fetchPokemon() {
        useCase
            .execute(id: id)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure:
                    self?.state = .failure
                case .finished:
                    self?.state = .success
                }
            }, receiveValue: { [weak self] pokemon in
                self?.pokemon = pokemon
            }).store(in: &bag)
    }
}

extension PokemonDetailViewModel {
    static func make(id: PokemonId) -> PokemonDetailViewModel {
        let serviceManager = ServiceManager()
        let repository = PokemonDetailRepository(serviceManager: serviceManager)
        let fetchPokemonUseCase = FetchPokemonUseCase(repository: repository)
        return PokemonDetailViewModel(id: id, useCase: fetchPokemonUseCase)
    }
}

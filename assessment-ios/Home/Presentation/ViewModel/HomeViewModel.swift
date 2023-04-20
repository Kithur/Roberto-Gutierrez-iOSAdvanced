//
//  HomeViewModel.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 18/04/23.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: ObservableObject {
    var pokemonArray: [Pokemon] { get set }
    func fetchPokemonList()
    func shouldFetchAdditionalPokemon(for index: Int)
}

final class HomeViewModel: HomeViewModelProtocol {
    @Published var pokemonArray = [Pokemon]()
    private var bag: Set<AnyCancellable> = Set<AnyCancellable>()
    private let fetchPokemonListUseCase: FetchPokemonListUseCaseProtocol
    private let writeToDatabaseUseCase: WriteToDatabaseUseCaseProtocol

    init(fetchPokemonListUseCase: FetchPokemonListUseCaseProtocol,
         writeToDatabaseUseCase: WriteToDatabaseUseCaseProtocol) {
        self.fetchPokemonListUseCase = fetchPokemonListUseCase
        self.writeToDatabaseUseCase = writeToDatabaseUseCase
    }
    
    func fetchPokemonList() {
        fetchPokemonListUseCase
            .execute(listCount: pokemonArray.count)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure:
                    break
                default:
                    break
                }
            }, receiveValue: { [weak self] pokemonList  in
                guard let self = self else { return }
                self.pokemonArray.append(contentsOf: pokemonList)
                self.writeToDatabaseUseCase.execute(pokemonList: pokemonList)
            }).store(in: &bag)
    }

    func shouldFetchAdditionalPokemon(for index: Int) {
        guard index == pokemonArray.count - 1,
        NetworkMonitor.shared.isConnected else { return }
        fetchPokemonList()
    }
}

extension HomeViewModel {
    static func make() -> HomeViewModel {
        let serviceManager = ServiceManager()
        let databaseManager = DatabaseManager()
        let repository = HomeViewRepository(serviceManager: serviceManager, databaseManager: databaseManager)
        let fetchPokemonListUseCase = FetchPokemonListUseCase(repository: repository)
        let writeToDatabaseUseCase = WriteToDatabaseUseCase(repository: repository)
        return HomeViewModel(fetchPokemonListUseCase: fetchPokemonListUseCase,
                             writeToDatabaseUseCase: writeToDatabaseUseCase)
    }
}

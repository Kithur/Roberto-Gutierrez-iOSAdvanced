//
//  FetchPokemonListUseCase.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import Foundation
import Combine

protocol FetchPokemonListUseCaseProtocol {
    func execute(listCount: Int) -> AnyPublisher<[Pokemon], Error>
}

final class FetchPokemonListUseCase: FetchPokemonListUseCaseProtocol {
    private let repository: HomeViewRepositoryProtocol

    init(repository: HomeViewRepositoryProtocol) {
        self.repository = repository
    }

    func execute(listCount: Int) -> AnyPublisher<[Pokemon], Error> {
        repository
            .fetchPokemonList(listCount: listCount)
            .eraseToAnyPublisher()
    }
}

//
//  ContentView.swift
//  assessment-ios
//
//  Created by Ivan Trejo on 15/04/23.
//

import SwiftUI
import Combine

struct HomeView<ViewModelProtocol: HomeViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModelProtocol
    @State var searchText: String = ""
    @State var isShowingDetailView: Bool = false
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: PokemonDetailView(
                        viewModel: PokemonDetailViewModel.make(id: .byName(name: searchText))
                ), isActive: $isShowingDetailView) {
                    EmptyView()
                }

                List(Array(viewModel.pokemonArray.enumerated()), id: \.offset) { index, pokemon in
                    NavigationLink(
                        destination: PokemonDetailView(
                            viewModel: PokemonDetailViewModel.make(id: .byNumber(id: index))
                        )
                    ) {
                        PokemonListItemView(model: PokemonListItemModel(name: pokemon.name,
                                                                        id: index))
                        .onAppear {
                            viewModel.shouldFetchAdditionalPokemon(for: index)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchPokemonList()
                }
                .navigationBarTitle("Pokemon List")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText, prompt: "Search a Pokemon")
                .onSubmit(of: .search) {
                    isShowingDetailView = true
                }
            }
        }
        .padding(.vertical)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel.make())
    }
}

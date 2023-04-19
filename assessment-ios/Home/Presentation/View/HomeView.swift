//
//  ContentView.swift
//  assessment-ios
//
//  Created by Ivan Trejo on 15/04/23.
//

import SwiftUI
import Combine

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            List(Array(viewModel.pokemonArray.enumerated()), id: \.offset) { index, pokemon in
                PokemonListItemView(model: PokemonListItemModel(name: pokemon.name,
                                                                id: index))
            }
            .onAppear {
                viewModel.fetchPokemonList()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

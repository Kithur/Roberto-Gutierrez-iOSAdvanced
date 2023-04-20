//
//  PokemonDetailView.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import SwiftUI
import Combine

struct PokemonDetailView<ViewModelProtocol: PokemonDetailViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModelProtocol

    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            case .success:
                if let pokemon = viewModel.pokemon {
                    PokemonDescriptionView(pokemon: pokemon)
                }
            case .failure:
                VStack {
                    Image("emptyState")
                        .resizable()
                        .frame(width: 300.0, height: 300.0)
                        .padding(.bottom)
                    Text("Pokemon not found.")
                        .font(.title)
                }
            }
        }
        .onAppear {
            viewModel.fetchPokemon()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(viewModel.pokemon?.id ?? "") \(viewModel.pokemon?.name.capitalized ?? "")").font(.title)
            }
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(viewModel: PokemonDetailViewModel.make(id: .byNumber(id: 1)))
    }
}

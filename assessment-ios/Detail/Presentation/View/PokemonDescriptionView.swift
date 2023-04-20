//
//  PokemonDescriptionView.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 19/04/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonDescriptionView: View {
    private var pokemon: PokemonDetail

    init(pokemon: PokemonDetail) {
        self.pokemon = pokemon
    }
    var body: some View {
        ScrollView {
            WebImage(url: pokemon.officialArtworkURL)
                .resizable()
                .placeholder {
                    Image("pokemonPlaceholder")
                        .resizable()
                        .frame(width: 300.0, height: 300.0)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 300.0, height: 300.0)
            .padding()
            HStack {
                VStack(alignment: .leading) {
                    Text("Characteristics:")
                        .font(.title2)
                        .padding(.vertical)
                    Text("Abilities: \(pokemon.printableAbilities)")
                    Text("Type: \(pokemon.printableTypes)")
                    Text("Height: \(pokemon.height)")
                    Text("Weight: \(pokemon.weight)")
                    Spacer()
                }
                .padding(.leading)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Stats:")
                        .font(.title2)
                        .padding(.vertical)
                    ForEach(pokemon.stats, id: \.self) { stat in
                        Text(stat)
                    }
                    Spacer()
                }
                .padding(.trailing)
            }
            Spacer()
        }
    }
}

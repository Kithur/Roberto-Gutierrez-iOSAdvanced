//
//  PokemonListItemView.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 18/04/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PokemonListItemView: View {
    var model: PokemonListItemModel
    
    var body: some View {
        HStack {
            WebImage(url: model.officialArtworkURL)
                .resizable()
                .placeholder {
                    Image("pokemonPlaceholder")
                        .resizable()
                        .frame(width: 64.0, height: 64.0)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 64.0, height: 64.0)
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.title)
                Text(model.dexNumber)
                    .font(.body)
            }
            .padding(.leading)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct PokemonListItemModel {
    let name: String
    let id: Int
    var dexNumber: String {
        String(id + 1)
    }
    var officialArtworkURL: URL? {
        PokemonRequest.officialArtwork(from: dexNumber)
    }
}

struct PokemonListItemView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListItemView(model: PokemonListItemModel(name: "Ditto", id: 131))
    }
}

//
//  Endpoint.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 18/04/23.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var url: String { get }
    func getFinalURL() -> URL?
}

enum PokemonRequest {
    case pagination(_ current: String)
    case id(_ id: String)
}

extension PokemonRequest {
    static func officialArtwork(from id: String) -> URL? {
        let stringURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
        return URL(string: stringURL)
    }
}

extension PokemonRequest: Endpoint {
    
    var base: String {
        return "https://pokeapi.co/api/v2/pokemon"
    }
    
    var url: String {
        switch self {
        case .pagination:
            return base
        case .id(let id):
            return "\(base)/\(id)"
        }
    }
    
    var params: [String: String]? {
        switch self {
        case .pagination(let current):
            return ["limit": "15",
                    "offset": current]
        case .id:
            return nil
        }
    }
    
    func getFinalURL() -> URL? {
        var queryItems: [URLQueryItem] = []
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        let urlString = url
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}

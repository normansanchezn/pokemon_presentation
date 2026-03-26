//
//  PokemonDetailsViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import Foundation
import pokemon_shared

public struct PokemonDetailsUIState {
    public var pokemon: Pokemon? = nil
    public var loading: Bool = false
    public var error: PokedexError? = nil
}

@MainActor
public final class PokemonDetailsViewModel: ObservableObject {
    
    @Published public private(set) var state = PokemonDetailsUIState()
    
    public init() {
        
    }
    
    public func getPokemonDetailsFromID(pokemonID: Int) async throws {
        let pokemon = Pokemon(id: 1, name: "Bulbasour", types: [PokemonType.grass], url: "")
        state.pokemon = pokemon
    }
}

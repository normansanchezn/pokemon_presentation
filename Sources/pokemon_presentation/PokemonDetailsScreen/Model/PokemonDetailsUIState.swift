//
//  PokemonDetailsUIState.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import Foundation
import pokemon_shared

public struct PokemonDetailsUIState {
    public var detailsPokemon: DetailsPokemon? = nil
    public var loading: Bool = false
    public var error: PokedexError? = nil
}

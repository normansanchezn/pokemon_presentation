//
//  PokemonDetailsViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import Foundation
import pokemon_shared
import Combine
import pokemon_domain

@MainActor
public final class PokemonDetailsViewModel: ObservableObject {
    
    @Published public private(set) var state = PokemonDetailsUIState()
    public let effects = PassthroughSubject<PokemonDetailsEffects, Never>()
    
    private let getPokemonDetailsUseCase: GetPokemonDetailsUseCase
    
    public init(getPokemonDetailsUseCase: GetPokemonDetailsUseCase) {
        self.getPokemonDetailsUseCase = getPokemonDetailsUseCase
    }
    
    public func getPokemonDetailsFromID(pokemonID: Int) async {
        if state.detailsPokemon?.id == pokemonID {
            return
        }

        state.loading = true

        defer {
            state.loading = false
        }

        do {
            state.error = nil
            let pokemon = try await getPokemonDetailsUseCase.execute(pokemonID: pokemonID)
            state.detailsPokemon = pokemon
        } catch {
            state.error = PokedexError(message: error.localizedDescription)
        }
    }
}

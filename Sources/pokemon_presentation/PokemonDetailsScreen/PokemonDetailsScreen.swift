//
//  PokemonDetailsScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import SwiftUI
import pokemon_shared
import pokemon_design_system

public struct PokemonDetailsScreen: View {
    
    public let pokemon: Pokemon
    
    public init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
    
    public var body: some View {
        PokemonBackground {
            VStack(alignment: .center, spacing: 0) {
                createHeaderPokemonDetails(pokemonUrl: pokemon.url)
                Text(pokemon.name.capitalized)
                    .font(Font.largeTitle.bold())
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .foregroundStyle(Color.white)
            }
        }
    }
    
    private func createHeaderPokemonDetails(pokemonUrl: String) -> some View {
        VStack(alignment: .center) {
            PokemonImage(
                pokeUrl: pokemon.url,
                size: 150
            )
            .padding(20)
        }
        .fixedSize()
        .background {
            Capsule().fill(cardGradient(for: pokemon.types))
        }
        .padding(.horizontal, 20)
    }
}

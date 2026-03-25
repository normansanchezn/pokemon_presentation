//
//  HomeScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 24/03/26.
//

import SwiftUI
import pokemon_shared
import pokemon_design_system
import pokemon_data

public struct HomeScreen: View {
    
    public init() {}
    
    public var body: some View {
        createContentView()
    }
    
    private func createContentView() -> some View {
        PokemonBackground {
            ScrollView {
                createHeaderMenu()
                createMenuPokemon()
            }
        }
    }
    
    private func createHeaderMenu() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("Menu Pokemon")
                    .foregroundStyle(Color.white)
                    .bold()
                    .font(.largeTitle)
                    .padding(.horizontal, 20)
                Spacer()
            }
            HStack {
                Text("Selecciona un pokémon para saber más información")
                    .foregroundStyle(Color.white)
                    .font(.title3)
                    .padding()
                Spacer()
            }
        }
    }
    
    private func createMenuPokemon() -> some View {
        VStack {
            ForEach(PokemonDataMock().getPokemonList().indices, id: \.self) { index in
                let pokemon = PokemonDataMock().getPokemonList()[index]
                
                PokemonCard(content: createPokemonItem(pokemon: pokemon))
            }
        }
    }
    
    private func createPokemonItem(pokemon: Pokemon) -> some View {
        VStack(spacing: 0) {
            PokemonImage(pokeUrl: pokemon.url)
        
            Text("\(pokemon.name.capitalized)")
                .foregroundStyle(Color.black)
                .font(Font.title2.bold())
            ListPokemonType(pokeTypes: pokemon.types)
        }
    }
}

//
//  HomeScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 24/03/26.
//

import SwiftUI
import pokemon_shared
import pokemon_design_system

public struct HomeScreen: View {
    private let pokemonList: [Pokemon]

    public init() {
        self.pokemonList = Self.previewPokemonList
    }

    public init(pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
    }

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
            ForEach(pokemonList, id: \.id) { pokemon in
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

    static let previewPokemonList: [Pokemon] = [
        .init(
            id: 1,
            name: "Bulbasaur",
            types: [.weed, .poison],
            url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/1.gif"
        ),
        .init(
            id: 4,
            name: "Charmander",
            types: [.fire, .dragon],
            url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/4.gif"
        ),
        .init(
            id: 7,
            name: "Squirtle",
            types: [.water],
            url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/7.gif"
        )
    ]
}

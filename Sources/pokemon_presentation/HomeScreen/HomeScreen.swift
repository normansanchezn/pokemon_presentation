//
//  HomeScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 24/03/26.
//

import SwiftUI
import Foundation
import pokemon_shared
import pokemon_design_system

public struct HomeScreen: View {
    @StateObject private var viewModel: HomeViewModel
    private let onEffect: (OnPokemonSelectedEffect) -> Void

    public init(
        viewModel: @autoclosure @escaping() -> HomeViewModel,
        onEffect: @escaping (OnPokemonSelectedEffect) -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.onEffect = onEffect
    }

    public var body: some View {
        PokemonBackground {
            VStack(spacing: 0) {
                createHeaderMenu()
                if viewModel.state.loading {
                    VStack {
                        Spacer(minLength: 0)
                        PokeballLoader(size: 100)
                        Spacer(minLength: 0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    createContentView()
                        .onAppear {
                            Task {
                                try await viewModel.onAppear()
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
    
    private func createContentView() -> some View {
        ScrollView {
            createMenuPokemon()
                .padding(.horizontal, 16)
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func createHomeHeader() -> some View {
        HStack {
            Text("Pokemon API")
                .foregroundStyle(Color.white)
                .bold()
                .font(.largeTitle)
                .padding(.horizontal, 20)
            Spacer()
        }
    }
    
    private func createSubHeadLineHomeScreen() -> some View {
        HStack {
            Text("Select a Pokemon to see more deatils")
                .foregroundStyle(Color.white)
                .font(.subheadline)
            Spacer()
        }.padding(.horizontal, 20)
    }
    
    private func createHeaderMenu() -> some View {
        VStack(spacing: 0) {
            PokemonCard(
                contentView: {
                    VStack(alignment: .center, spacing: 0) {
                        createHomeHeader()
                        createSubHeadLineHomeScreen()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                },
                backgroundColor: Color.red
            )
            .padding(.horizontal, 20)
        }
    }
    
    private func createMenuPokemon() -> some View {
        PokemonGridView(pokemons: viewModel.state.pokemonList)
    }
}

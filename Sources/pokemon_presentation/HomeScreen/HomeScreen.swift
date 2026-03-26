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
    @ObservedObject private var viewModel: HomeViewModel
    private let onEffect: (OnPokemonSelectedEffect) -> Void

    public init(
        viewModel: HomeViewModel,
        onEffect: @escaping (OnPokemonSelectedEffect) -> Void
    ) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.onEffect = onEffect
    }

    public var body: some View {
        PokemonBackground {
            ZStack(alignment: .top) {
                contentView
                topChrome
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            try? await viewModel.onAppear()
        }
    }
    
    private func showEmptyState() -> some View {
        VStack(alignment: .center) {
            Image("pokedex_place_holder")
            Text("We don't have pokemons to show")
        }
    }
    
    private func showError(_ message: String?) -> some View {
        VStack(alignment: .center) {
            Image("pokedex_place_holder")
            Text(message ?? "")
        }
    }
    
    private var contentView: some View {
        Group {
            if viewModel.state.loading {
                loadingView
            } else if viewModel.state.error != nil {
                showError(viewModel.state.error?.message)
            } else if viewModel.filteredPokemonList.isEmpty {
                showEmptyState()
            } else {
                createContentView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func createContentView() -> some View {
        ScrollView {
            createMenuPokemon()
                .padding(.top, 128)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var loadingView: some View {
        VStack {
            Spacer(minLength: 0)
            PokeballLoader(size: 100)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func createHomeHeader() -> some View {
        HStack {
            Text("Hello!")
                .foregroundStyle(Color.white)
                .bold()
                .font(.largeTitle)
                .padding(.horizontal, 20)
            Spacer()
        }
    }
    
    private func createSubHeadLineHomeScreen() -> some View {
        HStack {
            Text("It's nice to see you again")
                .foregroundStyle(Color.white)
                .font(.subheadline)
            Spacer()
        }.padding(.horizontal, 20)
    }
    
    private var topChrome: some View {
        VStack(spacing: 14) {
            leadingChrome
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var leadingChrome: some View {
        VStack(spacing: 0) {
            createHomeHeader()
            createSubHeadLineHomeScreen()
        }
        .padding()
        .glassEffect()
    }
    
    private func createMenuPokemon() -> some View {
        PokemonGridView(pokemons: viewModel.filteredPokemonList)
    }
}

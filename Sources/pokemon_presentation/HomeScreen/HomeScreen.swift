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
    @FocusState private var searchFocused: Bool

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
        .onAppear {
            Task {
                try? await viewModel.onAppear()
            }
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
                .padding(.top, 190)
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
            searchChrome
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

    private var searchChrome: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search pokemon",
                text: Binding(
                    get: { viewModel.state.searchQuery },
                    set: { viewModel.updateSearchQuery($0) }
                )
            )
            .focused($searchFocused)
            .autocorrectionDisabled()
            .submitLabel(.search)

            if !viewModel.state.searchQuery.isEmpty {
                Button {
                    viewModel.updateSearchQuery("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(height: 52)
        .background(.thinMaterial, in: Capsule())
        .glassEffect()
        .contentShape(Capsule())
    }
    
    private func createMenuPokemon() -> some View {
        PokemonGridView(pokemons: viewModel.filteredPokemonList) { pokemon in
            onEffect(.pokemonSelected(pokemonSelected: pokemon))
        }
    }
}

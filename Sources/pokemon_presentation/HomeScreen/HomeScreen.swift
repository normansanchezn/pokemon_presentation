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
            VStack(spacing: 16) {
                createHeaderMenu()
                createSearchField()
                contentView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 16)
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
    
    private func createHeaderMenu() -> some View {
        VStack(spacing: 0) {
            createHomeHeader()
            createSubHeadLineHomeScreen()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
        .glassEffect()
    }

    private func createSearchField() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(
                "Search pokemon",
                text: Binding(
                    get: { viewModel.state.searchQuery },
                    set: { viewModel.updateSearchQuery($0) }
                )
            )
            .autocorrectionDisabled()
            .submitLabel(.search)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }
    
    private func createMenuPokemon() -> some View {
        PokemonGridView(pokemons: viewModel.filteredPokemonList)
    }
}

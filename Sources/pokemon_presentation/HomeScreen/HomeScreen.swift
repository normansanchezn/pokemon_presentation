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
    @State private var didRequestSignUp = false
    @Environment(\.pokemonTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    public init(
        viewModel: HomeViewModel,
        onEffect: @escaping (OnPokemonSelectedEffect) -> Void
    ) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.onEffect = onEffect
    }

    public var body: some View {
        homeContent
            .onAppear {
                if viewModel.state.hasAccount {
                    Task {
                        try? await viewModel.onAppear()
                    }
                } else if !didRequestSignUp {
                    didRequestSignUp = true
                    onEffect(.goToSignUpView)
                }
            }
            .onChange(of: viewModel.state.hasAccount) { _, newValue in
                if newValue {
                    Task {
                        try? await viewModel.onAppear()
                    }
                }
            }
    }

    private var homeContent: some View {
        PokemonBackground {
            ZStack(alignment: .top) {
                contentView
                topChrome
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func showEmptyState() -> some View {
        VStack(alignment: .center) {
            Image("pokedex_place_holder")
            Text("We don't have pokemons to show")
                .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
        }
    }
    
    private func showError(_ message: String?) -> some View {
        VStack(alignment: .center) {
            Image("pokedex_place_holder")
            Text(message ?? "")
                .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
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
            VStack(spacing: theme.spacing.lg) {
                createMenuPokemon()

                if viewModel.state.loadingMore {
                    ProgressView()
                        .tint(theme.colors.textPrimary(for: colorScheme))
                        .padding(.vertical, theme.spacing.md)
                }
            }
            .padding(.top, theme.layout.contentTopSpacing)
            .padding(.horizontal, theme.layout.contentHorizontalPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var loadingView: some View {
        VStack {
            Spacer(minLength: 0)
            PokeballLoader(size: theme.sizes.loader)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func createHomeHeader() -> some View {
        HStack {
            Text("Hello!")
                .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
                .bold()
                .font(theme.typography.hero)
                .padding(.horizontal, theme.layout.screenHorizontalPadding)
            Spacer()
        }
    }
    
    private func createSubHeadLineHomeScreen() -> some View {
        HStack {
            Text("It's nice to see you again")
                .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                .font(theme.typography.subtitle)
            Spacer()
        }.padding(.horizontal, theme.layout.screenHorizontalPadding)
    }
    
    private var topChrome: some View {
        VStack(spacing: theme.layout.headerSpacing) {
            leadingChrome
            searchChrome
        }
        .padding(.horizontal, theme.layout.screenHorizontalPadding)
        .padding(.top, 16)
    }

    private var leadingChrome: some View {
        ZStack {
            VStack(spacing: 0) {
                createHomeHeader()
                createSubHeadLineHomeScreen()
            }
            .padding(theme.spacing.md)
            .glassEffect()
        }
        .frame(maxWidth: .infinity)
    }

    private var searchChrome: some View {
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(theme.colors.textSecondary(for: colorScheme))

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
            .foregroundStyle(theme.colors.textPrimary(for: colorScheme))

            if !viewModel.state.searchQuery.isEmpty {
                Button {
                    viewModel.updateSearchQuery("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                }
            }
        }
        .padding(.horizontal, theme.layout.searchFieldHorizontalPadding)
        .padding(.vertical, theme.layout.searchFieldVerticalPadding)
        .frame(height: theme.sizes.searchFieldHeight)
        .background(theme.colors.glassSurface(for: colorScheme), in: Capsule())
        .overlay {
            Capsule()
                .strokeBorder(theme.colors.glassBorder(for: colorScheme), lineWidth: 1)
        }
        .glassEffect()
        .contentShape(Capsule())
    }
    
    private func createMenuPokemon() -> some View {
        PokemonGridView(
            pokemons: viewModel.filteredPokemonList,
            onItemAppear: { pokemon in
                Task {
                    await viewModel.loadNextPageIfNeeded(currentPokemon: pokemon)
                }
            }
        ) { pokemon in
            onEffect(.pokemonSelected(pokemonIDSelected: pokemon.id))
        }
    }
}

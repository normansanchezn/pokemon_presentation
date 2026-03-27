//
//  PokemonDetailsScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import SwiftUI
import Foundation
import pokemon_domain
import pokemon_shared
import pokemon_design_system

public struct PokemonDetailsScreen: View {

    @Environment(\.pokemonTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    @ObservedObject private var viewModel: PokemonDetailsViewModel
    public let pokemonID: Int

    public init(pokemonID: Int, viewModel: PokemonDetailsViewModel) {
        self.pokemonID = pokemonID
        self.viewModel = viewModel
    }

    public var body: some View {
        PokemonBackground {
            content
        }
        .task(id: pokemonID) {
            await viewModel.getPokemonDetailsFromID(pokemonID: pokemonID)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.state.loading {
            VStack {
                Spacer()
                PokeballLoader(size: theme.sizes.loader)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let pokemon = viewModel.state.detailsPokemon {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: theme.spacing.xl) {
                    createHeaderPokemonDetails(pokemon: pokemon)
                        .padding(.bottom, 16)
                    createPokemonIdentitySection(pokemon: pokemon)
                    createPokemonDetailsContentView(pokemon: pokemon)
                        .padding(.horizontal, 20)
                    createMovesContentView(pokemon: pokemon)
                        .frame(maxWidth: .infinity)
                }
                .offset(y:-50)
                .padding(.horizontal, theme.layout.screenHorizontalPadding)
                .padding(.top, theme.spacing.sm)
                .padding(.bottom, theme.spacing.xl)
            }
        } else if viewModel.state.error != nil {
            showErrorState()
        } else {
            EmptyView()
        }
    }

    private func showErrorState() -> some View {
        VStack(spacing: theme.spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(theme.colors.textSecondary(for: colorScheme))

            Text("Something went wrong. Please try again.")
                .font(theme.typography.title)
                .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, theme.spacing.xl)
    }

    private func createPokemonIdentitySection(pokemon: DetailsPokemon) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text(pokemon.name.capitalized)
                .font(theme.typography.hero)
                .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)

            Text(theme.formattedPokemonNumber(pokemon.id))
                .font(theme.typography.headline.bold())
                .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background {
                    Capsule().fill(theme.colors.textPrimary(for: colorScheme).opacity(0.2))
                        .glassEffect()
                }
            
            Text(pokemon.description.isEmpty ? "No description available." : pokemon.description)
                .font(theme.typography.body)
                .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            ListPokemonType(pokeTypes: pokemon.types)
                .padding(.top, theme.spacing.xs)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func createPokemonDetailsContentView(pokemon: DetailsPokemon) -> some View {
        PokemonCard {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Details")
                    .font(theme.typography.calloutBold)
                    .foregroundStyle(theme.colors.textSecondary(for: colorScheme))

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: theme.spacing.md),
                        GridItem(.flexible(), spacing: theme.spacing.md)
                    ],
                    alignment: .leading,
                    spacing: theme.spacing.md
                ) {
                    createPokemonFieldDetail(detailName: "Weight", detailValue: pokemon.weight, icon: "scalemass")
                    createPokemonFieldDetail(detailName: "Height", detailValue: pokemon.height, icon: "ruler")
                    createPokemonFieldDetail(detailName: "Category", detailValue: pokemon.category, icon: "tag.fill")
                    createPokemonFieldDetail(detailName: "Main ability", detailValue: pokemon.mainAbility, icon: "sparkles")
                }
            }.padding(.horizontal, 20)
        }
    }

    private func createMovesContentView(pokemon: DetailsPokemon) -> some View {
        PokemonCard {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Moves")
                    .font(theme.typography.calloutBold)
                    .foregroundStyle(theme.colors.textPrimary(for: colorScheme))

                if pokemon.moves.isEmpty {
                    Text("No moves available.")
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                } else {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 70), spacing: theme.spacing.xs)],
                        alignment: .leading,
                        spacing: theme.spacing.xs
                    ) {
                        ForEach(pokemon.moves.prefix(10), id: \.self) { move in
                            Text(move)
                                .font(theme.typography.caption.weight(.semibold))
                                .foregroundStyle(theme.colors.textOnTint)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .padding(.horizontal, theme.spacing.sm)
                                .padding(.vertical, theme.spacing.xs)
                                .background {
                                    Capsule()
                                        .fill(theme.colors.brandBlue.opacity(0.80))
                                        .glassEffect()
                                }
                        }
                    }
                }
            }.padding(.horizontal, 20)
        }.padding(.horizontal, 20)
    }

    private func createPokemonFieldDetail(detailName: String, detailValue: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            Label(detailName, systemImage: icon)
                .labelStyle(.titleAndIcon)
                .font(theme.typography.caption)
                .foregroundStyle(theme.colors.textSecondary(for: colorScheme))

            Text(detailValue.isEmpty ? "Unavailable" : detailValue)
                .font(theme.typography.body.weight(.semibold))
                .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func createHeaderPokemonDetails(pokemon: DetailsPokemon) -> some View {
        PokemonCard(
            contentView: {
                VStack {
                    Image("leaf_icon", bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 165, height: 165)
                        .opacity(0.75)
                }
                .frame(maxWidth: .infinity, maxHeight: 450)
            },
            gradient: cardGradient(for: pokemon.types, theme: theme, colorScheme: colorScheme)
        ).overlay {
            PokemonImage(
                pokeUrl: pokemon.url,
                size: theme.sizes.pokemonSpriteDetail - 50
            )
            .offset(y: 70)
            .padding(.bottom, theme.spacing.xl)
            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 12)
        }

    }
}

#Preview {
    PokemonDetailsScreen(
        pokemonID: 1,
        viewModel: PokemonDetailsViewModel(getPokemonDetailsUseCase: PreviewGetPokemonDetailsUseCase())
    )
    .pokemonTheme(.shared)
}

private struct PreviewGetPokemonDetailsUseCase: GetPokemonDetailsUseCase {
    func execute(pokemonID: Int) async throws -> DetailsPokemon {
        DetailsPokemon(
            id: pokemonID,
            name: "bulbasaur",
            types: [.grass, .poison],
            url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/showdown/1.gif",
            description: "A strange seed was planted on its back at birth. The plant sprouts and grows with this Pokémon.",
            category: "Seed Pokémon",
            weight: "6.9 kg",
            height: "0.7 m",
            mainAbility: "Overgrow",
            moves: ["tackle", "vine whip", "razor leaf", "sleep powder"]
        )
    }
}

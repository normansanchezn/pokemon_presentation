//
//  PokemonDetailsScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import SwiftUI
import Foundation
import pokemon_shared
import pokemon_design_system

public struct PokemonDetailsScreen: View {
    
    @Environment(\.pokemonTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject private var viewModel: PokemonDetailsViewModel

    public let pokemonID: Int
    @State var weight: String = ""
    @State var height: String = ""
    
    public init(pokemonID: Int, viewModel: PokemonDetailsViewModel) {
        self.pokemonID = pokemonID
        self.viewModel = viewModel
    }
    
    public var body: some View {
        PokemonBackground {
            VStack(alignment: .leading, spacing: 0) {
                createHeaderPokemonDetails()
                VStack(alignment: .leading, spacing: 0) {
                    createPokemonName(name: "Poke", pokemonId: pokemonID)
                }
                .frame(maxWidth: .infinity)
                
                createPokemonDetailsContentView()
                .padding(.horizontal, theme.spacing.lg)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                try await viewModel.getPokemonDetailsFromID(pokemonID: pokemonID)
            }
        }
    }
    
    private func createPokemonDetailsContentView() -> some View {
        PokemonCard(contentView: {
            HStack(alignment: .center, spacing: 8) {
                VStack(spacing: 4) {
                    createPokemonFieldDetail(detailName: "Weight", detailValue: weight, icon: "scalemass")
                    createPokemonFieldDetail(detailName: "Category", detailValue: "Seed", icon: "aqi.low")
                }
                Spacer()
                VStack {
                    createPokemonFieldDetail(detailName: "Height", detailValue: height, icon: "ruler")
                    createPokemonFieldDetail(detailName: "Hability", detailValue: "Overgrow", icon: "dumbbell")
                }
            }
        }, backgroundColor: theme.colors.glassSurfaceStrong(for: colorScheme))
    }
    
    private func createPokemonName(name: String, pokemonId: Int) -> some View {
        VStack(spacing: 0) {
            Text(name.capitalized)
                .font(theme.typography.hero)
                .frame(maxWidth: .infinity)
                .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
            Text(theme.formattedPokemonNumber(pokemonId))
                .font(theme.typography.subtitle)
                .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
        }.padding(theme.spacing.lg)
        
    }
    
    private func createPokemonFieldDetail(detailName: String, detailValue: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("\(detailName)", systemImage: icon)
                .labelStyle(.titleAndIcon)
                .foregroundStyle(.secondary)
                .font(theme.typography.caption)
                .padding(.horizontal, 25)
            
            TextField(text: $weight, label: {
                Text(detailValue)
                    .font(theme.typography.body)
                    .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
            })
            .multilineTextAlignment(.center)
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.xs)
            .disabled(true)
            .background {
                Capsule().fill(theme.colors.glassSurface(for: colorScheme))
            }
            .padding(.horizontal, theme.spacing.lg)
            .frame(maxWidth: .infinity)
            
        }
    }
    
    private func createHeaderPokemonDetails() -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius:999, style: .continuous)
                .fill(cardGradient(for: [PokemonType.bug], theme: theme, colorScheme: colorScheme))
                .overlay {
                    Image("leaf_icon", bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .opacity(0.70)
                }
                .offset(y: -40)
            
            PokemonImage(
                pokeUrl: "url",
                size: theme.sizes.pokemonSpriteDetail
            ).offset(y: 40)
            .padding(.bottom, theme.spacing.lg)
            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 12)
            
            Spacer()
        }
        .ignoresSafeArea()
        .frame(height: 260)
    }
}

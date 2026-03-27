//
//  RegionsScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import SwiftUI
import pokemon_design_system
import pokemon_shared

public struct RegionsScreen: View {
    
    private let regionResources: [RegionResource] = RegionResourceFactory.getAllRegionResources()
    
    @Environment(\.pokemonTheme) var theme: PokemonTheme
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    public init() {
        
    }
    
    public var body: some View {
        content
    }
    
    public var content: some View {
        PokemonBackground {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Regions")
                        .font(Font.largeTitle.bold())
                        .padding(.top, 20)
                        .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
                    Text("Select some region to see more details")
                        .font(Font.subheadline)
                        .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
                        .padding(.bottom, 10)
                    ForEach(regionResources, id: \.self) { regionData in
                        createGenerationCard(regionData)
                            .padding(.bottom, 12)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func createGenerationCard(
        _ regionResource: RegionResource
    ) -> some View {
        PokemonCard(contentView: {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(regionResource.generationID.resolvedName())
                        .font(.headline)
                        .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
                    Text(regionResource.generationID.resolvedGenerationID())
                        .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                }
                Spacer()
                ForEach(regionResource.resources, id: \.self) { pokemonImageResource in
                    Image(pokemonImageResource)
                }
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, maxHeight: 320)
        }, imageRes: regionResource.regionBackground)
        .padding(.horizontal, 12)
    }
}

#Preview {
    RegionsScreen()
}

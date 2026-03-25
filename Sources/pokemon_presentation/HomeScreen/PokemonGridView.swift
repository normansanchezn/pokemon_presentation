import SwiftUI
import pokemon_shared
import pokemon_design_system

public struct PokemonGridView: View {
    private let pokemons: [Pokemon]
    
    public init(pokemons: [Pokemon]) {
        self.pokemons = pokemons
    }
    
    public var body: some View {
        LazyVGrid(
            columns: Array(
                repeating: GridItem(
                    .flexible(),
                    spacing: 12
                ),
                count: 3
            ),
            spacing: 12
        ) {
            ForEach(
                pokemons,
                id: \.id
            ) { pokemon in
                PokemonCard(contentView: {
                    gridItem(pokemon)
                }, backgroundColor: .clear)
                .background {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(cardGradient(for: pokemon.types))
                }
            }
        }
        .padding(.horizontal, 8)
    }
    
    // MARK: - Item Views
    private func gridItem(_ pokemon: Pokemon) -> some View {
        VStack(spacing: 8) {
            PokemonImage(pokeUrl: pokemon.url)
            Text(pokemon.name.capitalized)
                .font(.headline)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            ListPokemonType(pokeTypes: pokemon.types)
        }
        .frame(maxWidth: .infinity)
    }

    private func cardGradient(for types: [PokemonType]) -> LinearGradient {
        let colors = types.prefix(2).map { resolvedColorByType($0).opacity(0.95) }

        switch colors.count {
        case 0:
            return LinearGradient(
                colors: [
                    Color.gray.opacity(0.45),
                    Color.black.opacity(0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 1:
            return LinearGradient(
                colors: [
                    colors[0],
                    colors[0].opacity(0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: Array(colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

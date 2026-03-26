//
//  MainScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 25/03/26.
//

import SwiftUI
import pokemon_domain
import pokemon_shared

public struct MainScreen: View {
    private let homeViewModel: HomeViewModel
    private let onEffect: (OnPokemonSelectedEffect) -> Void

    public init(
        homeViewModel: HomeViewModel,
        onEffect: @escaping (OnPokemonSelectedEffect) -> Void
    ) {
        self.homeViewModel = homeViewModel
        self.onEffect = onEffect
    }

    public var body: some View {
        #if os(iOS)
        Group {
            tabView
                .tabBarMinimizeBehavior(.onScrollDown)
        }
        #else
        tabView
        #endif
    }

    private var tabView: some View {
        TabView {
            Tab("Pokedex", systemImage: "house") {
                HomeScreen(
                    viewModel: homeViewModel,
                    onEffect: onEffect
                )
            }

            Tab("Regions", systemImage: "mappin.and.ellipse") {
                placeholder(title: "Regions", systemImage: "mappin.and.ellipse")
            }

            Tab("Favs", systemImage: "heart.fill") {
                placeholder(title: "Favs", systemImage: "heart.fill")
            }

            Tab("More", systemImage: "ellipsis") {
                placeholder(title: "More", systemImage: "ellipsis")
            }
        }
    }

    private func placeholder(title: String, systemImage: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 42, weight: .semibold))
            Text(title)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MainScreen(
        homeViewModel: HomeViewModel(fetchPokemonListUseCase: PreviewUseCase()),
        onEffect: { _ in }
    )
}

private struct PreviewUseCase: FetchPokemonListUseCase {
    func execute() async throws -> [Pokemon] {
        []
    }
}

//
//  MainScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 25/03/26.
//

import SwiftUI
import pokemon_domain
import pokemon_shared

private enum MainTab: Hashable {
    case home
    case regions
    case favs
    case more
}

public struct MainScreen: View {
    @State private var selectedTab: MainTab = .home

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
        TabView(selection: $selectedTab) {
            HomeScreen(
                viewModel: homeViewModel,
                onEffect: onEffect
            )
            .tabItem {
                Label("Pokedex", systemImage: "house.lodge")
            }
            .tag(MainTab.home)

            placeholder(title: "Regions", systemImage: "mappin.and.ellipse")
                .tabItem {
                    Label("Regions", systemImage: "mappin.and.ellipse")
                }
                .tag(MainTab.regions)

            placeholder(title: "Favs", systemImage: "heart.fill")
                .tabItem {
                    Label("Favs", systemImage: "heart.fill")
                }
                .tag(MainTab.favs)

            placeholder(title: "More", systemImage: "ellipsis")
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
                .tag(MainTab.more)
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

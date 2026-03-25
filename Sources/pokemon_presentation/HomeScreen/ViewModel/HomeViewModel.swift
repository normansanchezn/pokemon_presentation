//
//  HomeViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 25/03/26.
//

import Foundation
import pokemon_domain
import SwiftUI
import Combine
import pokemon_shared

public struct PokedexError: Equatable {
    public let message: String
    public init(message: String) {
        self.message = message
    }
}

public struct HomeUIState: Equatable {
    public let title: String = "Pokemon Menu"
    public let subtitle: String = ""
    public var pokemonList: [Pokemon] = []
    public var loading: Bool = false
    public var isEmpty: Bool = false
    public var error: PokedexError? = nil
    public var searchQuery: String = ""

    public init() {}
}

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public private(set) var state = HomeUIState()
    public let effects = PassthroughSubject<OnPokemonSelectedEffect, Never>()
    
    private let fetchPokemonListUseCase: FetchPokemonListUseCase
    
    public init(fetchPokemonListUseCase: FetchPokemonListUseCase) {
        self.fetchPokemonListUseCase = fetchPokemonListUseCase
    }

    public func updateSearchQuery(_ searchQuery: String) {
        state.searchQuery = searchQuery
    }

    public var filteredPokemonList: [Pokemon] {
        let query = state.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return state.pokemonList
        }

        return state.pokemonList.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }
    
    public func onAppear() async throws {
        guard state.pokemonList.isEmpty else { return }

        do {
            state.loading = true
            let pokemonList = try await fetchPokemonListUseCase.execute()
            if (pokemonList.isEmpty) {
                state.isEmpty = true
                return
            } else {
                state.isEmpty = false
            }
            await MainActor.run {
                state.pokemonList = pokemonList
                state.loading = false
            }
            
        } catch {
            state.isEmpty = true
            state.error = PokedexError(
                message: "We have some issues, please try again."
            )
        }
    }
}

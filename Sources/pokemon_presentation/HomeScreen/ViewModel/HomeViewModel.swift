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
    private let pageSize = 24
    private var allPokemonList: [Pokemon] = []
    private var didLoadInitialPokemonList = false
    
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

        return allPokemonList.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }

    public func loadNextPageIfNeeded(currentPokemon: Pokemon) {
        guard state.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard currentPokemon.id == state.pokemonList.last?.id else { return }
        guard state.pokemonList.count < allPokemonList.count else { return }

        let nextPageCount = min(state.pokemonList.count + pageSize, allPokemonList.count)
        state.pokemonList = Array(allPokemonList.prefix(nextPageCount))
    }
    
    public func onAppear() async throws {
        guard !didLoadInitialPokemonList else { return }

        state.loading = true
        state.error = nil
        state.isEmpty = false
        defer {
            state.loading = false
        }

        do {
            let pokemonList = try await fetchPokemonListUseCase.execute()
            didLoadInitialPokemonList = true
            allPokemonList = pokemonList

            guard !pokemonList.isEmpty else {
                state.isEmpty = true
                state.pokemonList = []
                return
            }

            state.isEmpty = false
            state.pokemonList = Array(pokemonList.prefix(pageSize))
            
        } catch {
            state.isEmpty = true
            state.error = PokedexError(
                message: "We have some issues, please try again."
            )
        }
    }
}

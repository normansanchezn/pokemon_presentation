//
//  HomeViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 25/03/26.
//

import Foundation
import Combine
import pokemon_domain
import pokemon_shared

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public private(set) var state = HomeUIState()
    public let effects = PassthroughSubject<OnPokemonSelectedEffect, Never>()

    private let fetchPokemonListUseCase: FetchPokemonListUseCase
    private let pageSize = 24
    private var didLoadInitialPokemonList = false
    private var isPageLoadInFlight = false
    private var hasMorePages = true
    private var nextOffset = 0

    public init(fetchPokemonListUseCase: FetchPokemonListUseCase) {
        self.fetchPokemonListUseCase = fetchPokemonListUseCase
    }

    public func updateSearchQuery(_ searchQuery: String) {
        state.searchQuery = searchQuery
    }

    public func setHasAccount(_ hasAccount: Bool) {
        state.hasAccount = hasAccount
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

    public func loadNextPageIfNeeded(currentPokemon: Pokemon) async {
        guard state.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard currentPokemon.id == state.pokemonList.last?.id else { return }
        guard hasMorePages, !isPageLoadInFlight else { return }

        await loadPage(reset: false)
    }

    public func onAppear() async throws {
        guard !didLoadInitialPokemonList, !isPageLoadInFlight else { return }

        didLoadInitialPokemonList = await loadPage(reset: true)
    }

    @discardableResult
    private func loadPage(reset: Bool) async -> Bool {
        guard !isPageLoadInFlight else { return false }

        isPageLoadInFlight = true
        if reset {
            state.loading = true
            state.error = nil
            state.isEmpty = false
        } else {
            state.loadingMore = true
        }

        defer {
            state.loading = false
            state.loadingMore = false
            isPageLoadInFlight = false
        }

        do {
            let pokemonList = try await fetchPokemonListUseCase.execute(
                limit: pageSize,
                offset: nextOffset
            )

            hasMorePages = pokemonList.count == pageSize
            nextOffset += pokemonList.count

            if reset {
                state.pokemonList = pokemonList
            } else {
                state.pokemonList.append(contentsOf: pokemonList)
            }

            state.isEmpty = state.pokemonList.isEmpty
            return true
        } catch {
            if reset {
                state.isEmpty = true
                state.error = PokedexError(
                    message: "We have some issues, please try again."
                )
                state.pokemonList = []
            }
            return false
        }
    }
}

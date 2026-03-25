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

public struct HomeUIState: Equatable {
    public let title: String = "Pokemon Menu"
    public let subtitle: String = ""
    public var pokemonList: [Pokemon] = []
    public var loading: Bool = false

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
    
    public func onAppear() async throws {
        guard state.pokemonList.isEmpty else { return }

        do {
            state.loading = true
            let pokemonList = try await fetchPokemonListUseCase.execute()
            await MainActor.run {
                state.pokemonList = pokemonList
                state.loading = false
            }
            
        } catch {
            // TODO: surface error state when the MVI contract is ready.
        }
    }
}

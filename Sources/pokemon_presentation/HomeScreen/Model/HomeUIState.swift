//
//  HomeUIState.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import Foundation
import pokemon_shared

public struct HomeUIState: Equatable {
    public let title: String = "Pokemon Menu"
    public let subtitle: String = ""
    public var pokemonList: [Pokemon] = []
    public var loading: Bool = false
    public var loadingMore: Bool = false
    public var isEmpty: Bool = false
    public var error: PokedexError? = nil
    public var searchQuery: String = ""
    public var hasAccount: Bool = false

    public init() {}
}

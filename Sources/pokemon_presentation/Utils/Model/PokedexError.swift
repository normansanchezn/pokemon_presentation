//
//  PokedexError.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import Foundation

public struct PokedexError: Equatable {
    public let message: String
    public init(message: String) {
        self.message = message
    }
}

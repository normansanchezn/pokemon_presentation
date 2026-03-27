//
//  Region+Ext.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

public extension PokemonGeneration {
    func resolvedGenerationID() -> String {
        switch self {
        case .First:
            return "Generation I"
        case .Second:
            return "Generation II"
        case .Third:
            return "Generation III"
        case .Fourth:
            return "Generation IV"
        case .Fifth:
            return "Generation V"
        case .Sixth:
            return "Generation VI"
        case .Seventh:
            return "Generation VII"
        case .Eighth:
            return "Generation VIII"
        }
    }
    
    func resolvedName() -> String {
        switch self {
        case .First:"Kanto"
        case .Second:"Johto"
        case .Third:"Hoenn"
        case .Fourth:"Sinnoh"
        case .Fifth:"Unova"
        case .Sixth:"Kalos"
        case .Seventh: "Alola"
        case .Eighth: "Galar"
        }
    }
}

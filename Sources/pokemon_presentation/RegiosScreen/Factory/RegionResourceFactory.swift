//
//  RegionResourceFactory.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 26/03/26.
//

import SwiftUI

public struct RegionResource: Hashable {
    public var generationID: PokemonGeneration
    public var resources: [String]
    public var regionBackground: String
}

public enum RegionResourceFactory {
    public static func getAllRegionResources() -> [RegionResource] {
        [
            RegionResource(generationID: .First, resources:  ["pg1_1", "pg1_2", "pg1_3"], regionBackground: "kanto_bg"),
            RegionResource(generationID: .Second, resources:  ["pg2_1", "pg2_2", "pg2_3"], regionBackground: "johto_bg"),
            RegionResource(generationID: .Third, resources:  ["pg3_1", "pg3_2", "pg3_3"], regionBackground: "hoenn_bg"),
            RegionResource(generationID: .Fourth, resources:  ["pg4_1", "pg4_2", "pg4_3"], regionBackground: "sinnoh_bg"),
            RegionResource(generationID: .Fifth, resources:  ["pg5_1", "pg5_2", "pg5_3"], regionBackground: "unova_bg"),
            RegionResource(generationID: .Sixth, resources: ["pg6_1", "pg6_2", "pg6_3"], regionBackground: "kalos_bg"),
            RegionResource(generationID: .Seventh, resources: ["pg7_1", "pg7_2", "pg7_3"], regionBackground: "alola_bg"),
            RegionResource(generationID: .Eighth, resources: ["pg8_1", "pg8_2", "pg8_3"], regionBackground: "galar_bg"),
        ]
    }
}

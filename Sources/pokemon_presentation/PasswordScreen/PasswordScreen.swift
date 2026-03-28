//
//  PasswordScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 28/03/26.
//

import SwiftUI
import pokemon_design_system

public struct PasswordScreen: View {
    
    @ObservedObject var viewModel: PasswordViewModel
    
    public init(viewModel: PasswordViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        PokemonBackground {
            VStack(alignment: .leading) {
                PokemonTitle(title: viewModel.state.title)
                PokemonSubTitle(subtitle: viewModel.state.subtitle)
                
                PokemonCard {
                    
                }
                Spacer()
            }
        }
    }
}

#Preview {
    PasswordScreen(viewModel: PasswordViewModel())
}

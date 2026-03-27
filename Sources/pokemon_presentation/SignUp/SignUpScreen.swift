//
//  SignUpScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 27/03/26.
//

import SwiftUI
import pokemon_design_system

public struct SignUpScreen: View {
    
    @Environment(\.pokemonTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var viewModel: SignUpViewModel
    
    public init(
        viewModel: SignUpViewModel
    ) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        PokemonBackground {
            if viewModel.state.isLoading {
                loaderView
            } else if viewModel.state.error != nil {
                errorView
            } else {
                content
            }
        }
        .ignoresSafeArea()
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: 12) {
            Spacer()
            Image(viewModel.state.imageResource)
                .padding(.top, 20)
            PokemonCard {
                VStack(alignment:.leading) {
                    PokemonTitle(title: viewModel.state.titleScreen)
                    PokemonSubTitle(subtitle: viewModel.state.subTitleScreen)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 20)
            Spacer()
            PokemonButton(buttonText: viewModel.state.btnContinueTitle, style: .primary, action: {
                viewModel.effects.send(.continueSignUp)
            })
        }
    }
    
    private var loaderView: some View {
        VStack {
            Spacer()
            PokeballLoader(size: 200)
            Spacer()
        }
    }
    
    private var errorView: some View {
        VStack {
            Spacer()
            Image("pokedex_place_holder")
            Spacer()
        }
    }
}

#Preview {
    SignUpScreen(viewModel: SignUpViewModel())
}

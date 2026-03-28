//
//  SignUpScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 27/03/26.
//

import SwiftUI
import pokemon_design_system
import Combine

public struct SignUpScreen: View {
    
    @Environment(\.pokemonTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject private var viewModel: SignUpViewModel
    private let onEffect: (SignUpEffects) -> Void
    
    public init(
        viewModel: SignUpViewModel,
        onEffect: @escaping (SignUpEffects) -> Void = { _ in }
    ) {
        self.viewModel = viewModel
        self.onEffect = onEffect
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
        .safeAreaInset(edge: .bottom) {
            PokemonButton(buttonText: viewModel.state.btnContinueTitle, style: .primary, action: {
                viewModel.effects.send(.continueSignUp)
            }, isDisabled: viewModel.state.isDisabled)
        }
        .onReceive(viewModel.effects) { effect in
            onEffect(effect)
        }
    }
    
    private var content: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(viewModel.state.imageResource)
                .padding(.top, 20)
            PokemonTitle(title: viewModel.state.titleScreen)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            PokemonCard {
                VStack(alignment:.leading) {
                    PokemonSubTitle(subtitle: viewModel.state.subTitleScreen)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 20)
            Spacer()
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

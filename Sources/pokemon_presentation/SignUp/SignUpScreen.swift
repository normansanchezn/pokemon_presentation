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
    private let onContinue: () -> Void
    
    public init(
        viewModel: SignUpViewModel,
        onContinue: @escaping () -> Void = {}
    ) {
        self.viewModel = viewModel
        self.onContinue = onContinue
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
        .onReceive(viewModel.effects) { effect in
            switch effect {
            case .continueSignUp:
                onContinue()
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .center, spacing: 12) {
            Image("sign_up_img")
                .padding(.top, 20)
            PokemonCard {
                VStack(alignment:.leading) {
                    Text("All pokemon on the same place")
                        .font(theme.typography.hero.bold())
                        .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
                    Text("You can access to hole pokemon list and more.")
                        .font(theme.typography.subtitle.bold())
                        .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .padding(.horizontal, 20)
            Spacer()
            Button(action: {
                viewModel.effects.send(.continueSignUp)
            }, label: {
                Text(viewModel.state.btnContinueTitle)
                    .font(theme.typography.headline.bold())
                    .foregroundStyle(theme.colors.textPrimary(for: colorScheme))
            })
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                Capsule().fill(Color.blue.opacity(0.3))
                    .glassEffect()
            }
            .padding(20)
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

//
//  EmailScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 27/03/26.
//

import SwiftUI
import pokemon_design_system

public struct EmailScreen: View {
    
    @ObservedObject private var viewModel: EmailViewModel
    @Environment(\.pokemonTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    private let onEffect: (EmailViewModelEffects) -> Void
    
    public init(
        viewModel: EmailViewModel,
        onEffect: @escaping (EmailViewModelEffects) -> Void = { _ in }
    ) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.onEffect = onEffect
    }
    
    public var body: some View {
        PokemonBackground {
            VStack(alignment: .leading, spacing: 0) {
                PokemonTitle(title: viewModel.state.titleText)
                PokemonSubTitle(subtitle: viewModel.state.subtitleText)
                    .padding(.bottom, 20)
                emailFieldSection
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onReceive(viewModel.effects) { effect in
            onEffect(effect)
        }
        .safeAreaBar(edge: .bottom, content: {
            continueButton
        })
    }
    
    private var continueButton: some View {
        PokemonButton(
            buttonText: viewModel.state.continueButtonTitle,
            style: .primary,
            action: {
                viewModel.onContinueButtonListener()
            },
            isDisabled: viewModel.state.isContinueButtonDisabled
        )
    }
    
    private var emailFieldSection: some View {
        PokemonCard {
            VStack(alignment: .leading) {
                Text(viewModel.state.promptText)
                    .font(theme.typography.headline.bold())
                    .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                
                PokemonField(
                    model: PokemonFieldModel(
                        hintText: viewModel.state.fieldHintText,
                        helperText: viewModel.state.fieldHelperText,
                        errorMessage: Binding(
                            get: { viewModel.errorMessage },
                            set: { viewModel.updateErrorMessage($0) }
                        ),
                        value: Binding(
                            get: { viewModel.email },
                            set: { viewModel.updateEmail($0) }
                        )
                    )
                )
            }
            .padding(16)
        }
    }
}

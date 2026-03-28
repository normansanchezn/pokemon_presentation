//
//  PasswordScreen.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 28/03/26.
//

import SwiftUI
import pokemon_design_system

public struct PasswordScreen: View {
    
    @ObservedObject private var viewModel: PasswordViewModel
    @Environment(\.pokemonTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    private let onEffect: (PasswordViewModelEffects) -> Void

    public init(
        viewModel: PasswordViewModel,
        onEffect: @escaping (PasswordViewModelEffects) -> Void = { _ in }
    ) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.onEffect = onEffect
    }
    
    public var body: some View {
        PokemonBackground {
            VStack(alignment: .leading) {
                PokemonTitle(title: viewModel.state.title)
                PokemonSubTitle(subtitle: viewModel.state.subtitle)
                    .padding(.bottom, theme.spacing.md)

                PokemonCard {
                    PokemonField(
                        model: PokemonFieldModel(
                            hintText: viewModel.state.hintFieldText,
                            helperText: viewModel.state.helpFieldText,
                            errorMessage: .constant(""),
                            value: Binding(
                                get: { viewModel.password },
                                set: { viewModel.updatePassword($0) }
                            )
                        )
                    )
                    .padding(theme.spacing.md)
                }
                .padding(.horizontal, theme.spacing.xs)

                PokemonListCheckBox(
                    requirements: passwordRequirementModels
                )
                .padding(.horizontal, theme.spacing.lg)
                .padding(.top, theme.spacing.sm)

                Spacer()
            }
            .padding(.horizontal, theme.layout.screenHorizontalPadding)
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onReceive(viewModel.effects) { effect in
            onEffect(effect)
        }
        .safeAreaBar(edge: .bottom, content: {
            PokemonButton(
                buttonText: viewModel.state.buttonText,
                style: .primary,
                action: {
                    viewModel.onContinueButtonListener()
                },
                isDisabled: viewModel.state.isContinueButtonDisabled
            )
        })
    }

    private var passwordRequirementModels: [PokemonCheckBoxListModel] {
        [
            PokemonCheckBoxListModel(
                requirement: viewModel.state.capitalLetterRequirementText,
                isEnabled: .constant(viewModel.state.hasCapitalLetter)
            ),
            PokemonCheckBoxListModel(
                requirement: viewModel.state.numberRequirementText,
                isEnabled: .constant(viewModel.state.hasNumber)
            ),
            PokemonCheckBoxListModel(
                requirement: viewModel.state.specialCharacterRequirementText,
                isEnabled: .constant(viewModel.state.hasSpecialCharacter)
            ),
            PokemonCheckBoxListModel(
                requirement: viewModel.state.minimumLengthRequirementText,
                isEnabled: .constant(viewModel.state.hasMinimumLength)
            )
        ]
    }
}

#Preview {
    PasswordScreen(viewModel: PasswordViewModel())
        .pokemonTheme(.shared)
}

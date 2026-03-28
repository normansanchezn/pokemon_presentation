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
                Text(viewModel.state.promptText)
                    .font(theme.typography.headline.bold())
                    .foregroundStyle(theme.colors.textSecondary(for: colorScheme))
                    .padding(.bottom, theme.spacing.sm)
                
                PokemonField(
                    model: PokemonFieldModel(
                        hintText: viewModel.state.fieldHintText,
                        helperText: viewModel.state.fieldHelperText,
                        value: Binding(
                            get: { viewModel.email },
                            set: { viewModel.updateEmail($0) }
                        )
                    )
                )

                if let validationMessage = viewModel.state.validationMessage {
                    Text(validationMessage)
                        .font(theme.typography.caption.bold())
                        .foregroundStyle(theme.colors.brandRed)
                        .padding(.top, theme.spacing.xs)
                }

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
            PokemonButton(
                buttonText: viewModel.state.continueButtonTitle,
                style: .primary,
                action: {
                    viewModel.onContinueButtonListener()
                },
                isDisabled: viewModel.state.isContinueButtonDisabled
            )
        })
    }
}

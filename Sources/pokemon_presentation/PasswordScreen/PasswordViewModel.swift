//
//  PasswordViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 28/03/26.
//

import Foundation
import Combine

@MainActor
public final class PasswordViewModel: ObservableObject {
    
    @Published public private(set) var state = PasswordUIState()
    @Published public private(set) var password: String = ""

    public let effects = PassthroughSubject<PasswordViewModelEffects, Never>()

    public init() {}

    public func onAppear() {
        validatePassword(password)
    }

    public func updatePassword(_ newPassword: String) {
        password = newPassword
        validatePassword(newPassword)
    }

    public func onContinueButtonListener() {
        validatePassword(password)

        guard state.isContinueButtonDisabled == false else {
            return
        }

        effects.send(.createAccount)
    }

    private func validatePassword(_ rawPassword: String) {
        let trimmedPassword = rawPassword.trimmingCharacters(in: .whitespacesAndNewlines)

        state.hasCapitalLetter = matches(trimmedPassword, pattern: ".*[A-Z].*")
        state.hasNumber = matches(trimmedPassword, pattern: ".*[0-9].*")
        state.hasSpecialCharacter = matches(trimmedPassword, pattern: ".*[!@#$%^&*(),.?\":{}|<>].*")
        state.hasMinimumLength = trimmedPassword.count >= 8

        let isValid = state.hasCapitalLetter
            && state.hasNumber
            && state.hasSpecialCharacter
            && state.hasMinimumLength

        state.isContinueButtonDisabled = !isValid
    }

    private func matches(_ text: String, pattern: String) -> Bool {
        text.range(of: pattern, options: .regularExpression) != nil
    }
}

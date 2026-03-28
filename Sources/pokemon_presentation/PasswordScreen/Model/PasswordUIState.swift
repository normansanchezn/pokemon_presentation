//
//  PasswordUIState.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 28/03/26.
//

import Foundation

public struct PasswordUIState {
    public let title: String = "Create a strong \npassword"
    public let subtitle: String = "We need you to make a strong password to create your account."
    public let hintFieldText: String = "Password"
    public let helpFieldText: String = "As you write your password, we'll check these requirements."
    public let capitalLetterRequirementText: String = "One capital letter"
    public let numberRequirementText: String = "One number"
    public let specialCharacterRequirementText: String = "One special character"
    public let minimumLengthRequirementText: String = "At least 8 characters"
    public let buttonText: String = "Create Account"

    public var hasCapitalLetter: Bool = false
    public var hasNumber: Bool = false
    public var hasSpecialCharacter: Bool = false
    public var hasMinimumLength: Bool = false
    public var isContinueButtonDisabled: Bool = true

    public init() {}
}

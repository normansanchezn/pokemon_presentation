//
//  EmailUIState.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 28/03/26.
//

import Foundation

public struct EmailUIState {
    public let titleText = "Create your account"
    public let subtitleText = "Almost there. Add an email so we can keep your progress in sync."
    public let promptText = "What is your email address?"
    public let fieldHelperText = "We'll use this to create your account."
    public let fieldHintText = "email@domain.com"
    public let continueButtonTitle = "Continue"
    public let emptyEmailMessage = "Please enter your email address."
    public let invalidEmailMessage = "Please enter a valid email address."
    public var validationMessage: String? = nil
    public var isContinueButtonDisabled: Bool = true
    public var isLoading: Bool = false

    public init() {}
}

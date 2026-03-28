//
//  EmailViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 27/03/26.
//

import SwiftUI
import Foundation
import Combine

@MainActor
public final class EmailViewModel: ObservableObject {
    
    @Published public private(set) var state = EmailUIState()
    @Published public private(set) var email: String = ""
    @Published public private(set) var errorMessage: String = ""

    public let effects = PassthroughSubject<EmailViewModelEffects, Never>()
    
    public init() {}
    
    public func onAppear() {
        validateEmail(email)
    }
    
    public func updateEmail(_ newValue: String) {
        email = newValue
        validateEmail(newValue)
    }
    
    public func updateErrorMessage(_ newValue: String) {
        errorMessage = newValue
        validateEmail(email)
    }
    
    public func validateEmail(_ rawEmail: String) {
        let trimmedEmail = rawEmail.trimmingCharacters(in: .whitespacesAndNewlines)

        if Self.isValidEmail(trimmedEmail) {
            state.isContinueButtonDisabled = false
            errorMessage = ""
            return
        }
        if !trimmedEmail.isEmpty && !Self.isValidEmail(trimmedEmail) {
            state.isContinueButtonDisabled = true
            errorMessage = "Please enter a valid email"
            return
        }
        if trimmedEmail.isEmpty {
            state.isContinueButtonDisabled = false
            errorMessage = ""
        }
    }

    public func onContinueButtonListener() {
        validateEmail(email)

        guard state.isContinueButtonDisabled == false else {
            if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                state.validationMessage = state.emptyEmailMessage
            }
            return
        }

        effects.send(.createAccount)
    }

    private static func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}

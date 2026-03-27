//
//  SignUpViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 27/03/26.
//

import Foundation
import Combine

public struct SignUpUIState {
    public var isLoading: Bool = false
    public var error: Error? = nil
    public let titleScreen = "Sign Up"
    public let subTitleScreen = "Create your account"
    public let btnContinueTitle = "Continue"
    public let imageResource = "sign_up_img"
}

public enum SignUpEffects {
    case continueSignUp
}

@MainActor
public final class SignUpViewModel: ObservableObject {
    
    @Published public private(set) var state = SignUpUIState()
    public let effects = PassthroughSubject<SignUpEffects, Never>()
    
    public init() {
        
    }
    
}

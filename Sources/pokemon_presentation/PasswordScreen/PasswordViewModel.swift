//
//  PasswordViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 28/03/26.
//

import Foundation

public struct PasswordUIState {
    public var title: String = "Create an strong \npassword"
    public var subtitle: String = "We need to you make an strong password to create your account."
}

@MainActor
public final class PasswordViewModel: ObservableObject {
    
    @Published public var state: PasswordUIState = PasswordUIState()
    
    
}

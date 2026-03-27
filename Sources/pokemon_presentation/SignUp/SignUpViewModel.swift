//
//  SignUpViewModel.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 27/03/26.
//

import Foundation
import Combine

@MainActor
public final class SignUpViewModel: ObservableObject {
    
    @Published public private(set) var state = SignUpUIState()
    public let effects = PassthroughSubject<SignUpEffects, Never>()
    
    public init() { }

}

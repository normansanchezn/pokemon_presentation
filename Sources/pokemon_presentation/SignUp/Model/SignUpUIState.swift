//
//  SignUpUIState.swift
//  pokemon_presentation
//
//  Created by Norman Sánchez on 27/03/26.
//


public struct SignUpUIState {
    public var isLoading: Bool = false
    public var error: Error? = nil
    public let titleScreen = "All Pokémon in one \nplace"
    public let subTitleScreen = "Access a vast list of Pokémon from all generations ever made by Nintendo. \nYou need to sign up to get better experience."
    public let btnContinueTitle = "Sign up"
    public let imageResource = "sign_up_img"
    public let isDisabled = false
}

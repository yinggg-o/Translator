//
//  TranslatorApp.swift
//  Translator
//
//  Created by suhm on 2024/11/24.
//

import SwiftUI

@main
struct TranslatorApp: App {
    @StateObject private var userLoginStatus = UserLoginStatus()

    var body: some Scene {
        WindowGroup {
            TranslatorView()
             .environmentObject(userLoginStatus)
        }
    }
}


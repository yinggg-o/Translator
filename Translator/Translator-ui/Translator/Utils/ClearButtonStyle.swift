//
//  ClearButtonStyle.swift
//  Translator
//
//  Created by suhm on 2024/11/26.
//

import SwiftUI

struct ClearButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.clear)
            .foregroundColor(.primary)
            .cornerRadius(8)
            .shadow(radius: configuration.isPressed ? 0 : 2)
    }
}


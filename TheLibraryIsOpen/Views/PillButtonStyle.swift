//
//  PillButtonStyle.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 12/03/21.
//

import SwiftUI

struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 50)
            .background(Color.accentColor)
            .cornerRadius(50)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

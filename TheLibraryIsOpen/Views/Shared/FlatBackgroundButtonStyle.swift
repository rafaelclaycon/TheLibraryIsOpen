import SwiftUI

struct FlatBackgroundButtonStyle: ButtonStyle {
    
    let foregroundColor: Color
    let verticalPadding: CGFloat
    let horizontalPadding: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(foregroundColor)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }

}

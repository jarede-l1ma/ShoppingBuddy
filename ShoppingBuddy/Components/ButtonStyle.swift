import SwiftUI

/// A custom button style that creates a primary button appearance.
/// - Usage: Typically used for main actions in the interface.
/// - Appearance: Blue background with white text, 8pt corner radius, and padding.
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

/// A custom button style that creates a secondary button appearance.
/// - Usage: Typically used for less prominent or secondary actions.
/// - Appearance: Gray background with white text, 8pt corner radius, and padding.
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

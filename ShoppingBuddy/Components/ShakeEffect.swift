import SwiftUI

/// A custom geometry effect that creates a horizontal shaking animation.
///
/// ## Usage:
/// Apply to any view using the `.modifier()` or `.effect()` modifier:
/// ```swift
/// Text("Alert!")
///     .modifier(ShakeEffect(animatableData: shakeCount))
/// ```
///
/// To animate, change the `animatableData` value (typically in response to an event):
/// ```swift
/// @State private var shakeCount: CGFloat = 0
///
/// Button("Shake") {
///     withAnimation(.default) {
///         shakeCount += 1
///     }
/// }
/// ```
///
/// ## Customization:
/// - `amount`: Maximum horizontal displacement (default: 8 points)
/// - `shakesPerUnit`: Number of oscillations per shake count (default: 3)
struct ShakeEffect: GeometryEffect {
    /// The maximum horizontal displacement of the shake effect
    var amount: CGFloat = 8
    
    /// The frequency of oscillations (higher values create more shakes)
    var shakesPerUnit: CGFloat = 3
    
    /// The animatable parameter that drives the effect.
    /// Increment this value to trigger the shake animation.
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        // Calculate horizontal displacement using sine wave
        let translation = amount * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

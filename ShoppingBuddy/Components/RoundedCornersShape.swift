import SwiftUI

extension View {
    /// Applies corner radius to specific corners of the view.
    /// - Parameters:
    ///   - radius: The radius of the rounded corners. Use `.infinity` for maximum rounding.
    ///   - corners: The corners to apply rounding to (e.g., [.topLeft, .topRight]).
    /// - Returns: A view with the specified corners rounded.
    ///
    /// ## Usage Example:
    /// ```swift
    /// Rectangle()
    ///     .cornerRadius(20, corners: [.topLeft, .bottomRight])
    /// ```
    ///
    /// ## Notes:
    /// - This is particularly useful when you need different rounding than SwiftUI's standard `.cornerRadius()`
    /// - Works with any SwiftUI view (buttons, rectangles, stacks, etc.)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

/// A custom shape that rounds specific corners of a rectangle.
///
/// ## Purpose:
/// Enables selective corner rounding which isn't natively available in SwiftUI.
/// Used internally by the `cornerRadius(_:corners:)` view modifier.
///
/// ## Parameters:
/// - `radius`: The rounding radius (`.infinity` creates circular corners)
/// - `corners`: Which corners to round (defaults to all corners)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

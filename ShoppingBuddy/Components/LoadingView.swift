import SwiftUI

/// A standardized loading indicator view with app branding.
///
/// Displays:
/// - The app name (localized) in large bold text
/// - A spinning progress indicator centered below the app name
/// - Smooth opacity transitions when appearing/disappearing
///
/// ## Usage
/// ```swift
/// // Show during loading states
/// if isLoading {
///     LoadingView()
/// }
/// ```
///
/// ## Customization
/// - Automatically uses localized app name from `CommonsStrings`
/// - Progress indicator uses system blue color by default
/// - Includes built-in opacity transition animation
struct LoadingView: View {
    var body: some View {
        VStack {
            // App name title (localized)
            Text(CommonsStrings.appName.localized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            // Circular progress indicator
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5) // Enlarged 1.5x for better visibility
        }
        .transition(.opacity) // Fade in/out animation
    }
}

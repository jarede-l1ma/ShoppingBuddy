import Foundation

/// Provides localized strings for common application-wide text resources.
///
/// This enum serves as a centralized location for all common strings used throughout the app,
/// enabling consistent text usage and easy localization management.
///
/// ## Usage Example:
/// ```swift
/// Text(CommonsStrings.appName.localized)
///     .font(.title)
/// ```
///
/// ## Localization:
/// - Strings are localized using the "CommonsStrings" strings table
/// - Supports multiple languages through Localizable.strings files
/// - Automatically falls back to the raw value if no localization is found
enum CommonsStrings: String {
    /// The application's display name
    /// - Localization Key: "appName"
    /// - Default Value: "ShoppingBuddy" (or raw value)
    case appName
    
    /// Returns the localized version of the common string
    /// - Uses the "CommonsStrings" strings table for localization
    /// - Returns the raw value if no localized string is found
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "CommonsStrings")
    }
}

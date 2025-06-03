/// Provides localized strings for all button labels and alert messages in the app.
///
/// This enum serves as a centralized location for all button-related text,
/// enabling easy localization management and consistent text usage throughout the app.
///
/// ## Usage Example:
/// ```swift
/// Button(ButtonsStrings.save.localized) {
///     // Save action
/// }
///
/// Alert(ButtonsStrings.removeItemAlertTitle.localized, ...)
/// ```
///
/// ## Localization:
/// - All strings are localized using the "ButtonStrings" strings table
/// - Supports multiple languages through Localizable.strings files
enum ButtonsStrings: String {
    // MARK: - Basic Actions
    
    case cancel
    case remove
    case clear
    case add
    case save
    case purchased
    case edit
    
    // MARK: - Alert Messages
    
    case removeItemAlertTitle
    case removeItemAlertMessage
    case removeAllItemsAlertTitle
    case removeAllItemsAlertMessage
    
    /// Returns the localized version of the button string
    /// - Uses the "ButtonStrings" strings table for localization
    /// - Falls back to the raw value if no localization is found
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "ButtonStrings")
    }
}

/// Provides localized strings for text fields and their validation messages in the application.
///
/// Centralizes all text field related strings to ensure consistency and simplify localization management.
/// Used primarily for text field placeholders, labels, and validation messages.
///
/// ## Localization:
/// - Uses the "TextfieldStrings" strings table
/// - Falls back to raw value if no localized string is found
///
/// ## Usage Examples:
/// ```swift
/// TextField(TextfieldStrings.productName.localized, text: $productName)
///
/// Text(TextfieldStrings.itemAlreadyExists.localized)
///     .foregroundColor(.red)
/// ```
enum TextfieldStrings: String {
    /// Placeholder/Label for product name text field
    /// Localization Key: "productName"
    case productName
    
    /// Placeholder/Label for quantity input field
    /// Localization Key: "quantityItem"
    case quantityItem
    
    /// Placeholder/Label for unit price/value field
    /// Localization Key: "unitValue"
    case unitValue
    
    /// Validation message shown when attempting to add a duplicate item
    /// Localization Key: "itemAlreadyExists"
    case itemAlreadyExists
    
    /// Label for section selection field
    /// Localization Key: "section"
    case section
    
    /// Returns the localized string from the TextfieldStrings table
    /// - Returns: Localized version of the string, or raw value if not found
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "TextfieldStrings")
    }
}

/// Provides localized strings for labels and text in item row views.
///
/// This enum centralizes all UI strings related to item row presentation,
/// ensuring consistent labeling throughout the app and easy localization management.
///
/// ## Usage Example:
/// ```swift
/// Text("\(ItemRowStrings.quantity.localized): \(item.quantity)")
/// ```
///
/// ## Localization:
/// - Uses the "ItemRowStrings" strings table
/// - Falls back to raw value if no localization exists
enum ItemRowStrings: String {
    /// Label for item quantity (e.g., "Quantity: 3")
    case quantity
    
    /// Label for unit price/value (e.g., "Unit price: $2.99")
    case unitValue
    
    /// Label for total item value (quantity × unit price)
    case total
    
    /// Label for purchased items total section
    case purchaseTotal
    
    /// Returns the localized string from the ItemRowStrings table
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "ItemRowStrings")
    }
}

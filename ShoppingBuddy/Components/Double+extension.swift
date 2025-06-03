import Foundation

/// Converts the Double value to a localized currency string.
/// - Parameter localeIdentifier: A locale identifier string (default is "pt_BR" for Brazilian Portuguese).
/// - Returns: A formatted currency string based on the specified locale.
///            Returns "R$ 0,00" as fallback if formatting fails.
///
/// Example usage:
/// ```
/// let price = 19.99
/// price.toCurrency() // Returns "R$ 19,99" (default Brazilian format)
/// price.toCurrency(localeIdentifier: "en_US") // Returns "$19.99"
/// price.toCurrency(localeIdentifier: "de_DE") // Returns "19,99 €"
/// ```
extension Double {
    func toCurrency(localeIdentifier: String = "pt_BR") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter.string(from: NSNumber(value: self)) ?? "R$ 0,00"
    }
}

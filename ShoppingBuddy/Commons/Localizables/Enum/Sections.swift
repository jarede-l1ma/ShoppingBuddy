import SwiftUI

/// Represents the different product categories/sections in the shopping application.
///
/// This enum defines all available shopping categories with their associated properties,
/// conforming to multiple protocols for seamless integration with SwiftUI and data persistence.
///
/// ## Conformance:
/// - `String`: Raw value represents the section key
/// - `CaseIterable`: Enables iteration over all cases
/// - `Identifiable`: Required for SwiftUI list operations
/// - `Codable`: Supports serialization for persistence
///
/// ## Usage Examples:
/// ```swift
/// // Using in a Picker
/// Picker("Category", selection: $selectedSection) {
///     ForEach(Sections.sortedAlphabetically()) { section in
///         Text(section.localized)
///     }
/// }
///
/// // Accessing section color
/// section.color
/// ```
enum Sections: String, CaseIterable, Identifiable, Codable {
    case frozen
    case dairy
    case pasta
    case condiments
    case snacks
    case fruits
    case beverages
    case hygiene
    case cleaning
    case others
    
    /// Provides a unique identifier for each case (required by Identifiable)
    /// Uses the raw string value as ID for consistency
    var id: String { rawValue }

    /// Returns the localized display name for the section
    /// - Uses the "SectionStrings" strings table for localization
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "SectionStrings")
    }

    /// Returns the associated color for the section from the asset catalog
    /// - Falls back to clear color if the named color isn't found
    var color: Color {
        Color(UIColor(named: self.rawValue) ?? .clear)
    }

    /// Returns all sections sorted alphabetically by their localized names
    /// - Uses localized string comparison for proper alphabetical sorting
    /// - Respects the user's current locale settings
    static func sortedAlphabetically() -> [Sections] {
        return allCases.sorted {
            $0.localized.localizedCompare($1.localized) == .orderedAscending
        }
    }
}

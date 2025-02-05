import SwiftUI

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
    
    var id: String { rawValue }
    
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "SectionStrings")
    }
    
    var color: Color {
        Color(UIColor(named: self.rawValue) ?? .clear)
    }
}

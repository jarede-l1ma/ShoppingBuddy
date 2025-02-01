import SwiftUI

enum ShoppingSection: String, CaseIterable, Identifiable, Codable {
    case frozen = "Frios"
    case dairy = "Lacticínios e derivados"
    case pasta = "Massas e cereais"
    case condiments = "Temperos e condimentos"
    case snacks = "Snacks"
    case fruits = "Frutas e verduras"
    case beverages = "Bebidas"
    case hygiene = "Higiene"
    case cleaning = "Limpeza"
    case others = "Outros"
    
    var id: String { rawValue }
    
    var localizedName: LocalizedStringKey {
        LocalizedStringKey(self.rawValue)
    }
    
    var color: Color {
        switch self {
        case .frozen: return SectionColor.darkSlateGray.color
        case .dairy: return SectionColor.terracottaPink.color
        case .pasta: return SectionColor.gingerBrown.color
        case .condiments: return SectionColor.darkOliveGreen.color
        case .snacks: return SectionColor.deepMagenta.color
        case .fruits: return SectionColor.cranberryRed.color
        case .beverages: return SectionColor.deepCaramel.color
        case .hygiene: return SectionColor.deepTeal.color
        case .cleaning: return SectionColor.navyBlue.color
        case .others: return SectionColor.darkGoldenrod.color
        }
    }
}

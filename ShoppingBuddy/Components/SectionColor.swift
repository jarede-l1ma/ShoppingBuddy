import SwiftUI

enum SectionColor {
    case darkSlateGray
    case terracottaPink
    case gingerBrown
    case darkOliveGreen
    case deepMagenta
    case cranberryRed
    case deepCaramel
    case deepTeal
    case navyBlue
    case darkGoldenrod
    
    var color: Color {
        switch self {
        case .darkSlateGray: return Color(red: 47/255, green: 79/255, blue: 79/255)
        case .terracottaPink: return Color(red: 204/255, green: 102/255, blue: 102/255)
        case .gingerBrown: return Color(red: 176/255, green: 95/255, blue: 57/255)
        case .darkOliveGreen: return Color(red: 85/255, green: 107/255, blue: 47/255)
        case .deepMagenta: return Color(red: 128/255, green: 0/255, blue: 128/255)
        case .cranberryRed: return Color(red: 157/255, green: 34/255, blue: 53/255)
        case .deepCaramel: return Color(red: 111/255, green: 78/255, blue: 55/255)
        case .deepTeal: return Color(red: 0/255, green: 128/255, blue: 128/255)
        case .navyBlue: return Color(red: 0/255, green: 0/255, blue: 128/255)
        case .darkGoldenrod: return Color(red: 184/255, green: 134/255, blue: 11/255)
        }
    }
}

import Foundation

enum CommonsStrings: String {
    case appName
    
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "CommonsStrings")
    }
}

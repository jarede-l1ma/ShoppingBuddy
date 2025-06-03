enum ButtonsStrings: String {
    case cancel
    case remove
    case clear
    case add
    case save
    case purchased
    case edit
    case removeItemAlertTitle
    case removeItemAlertMessage
    case removeAllItemsAlertTitle
    case removeAllItemsAlertMessage

    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "ButtonStrings")
    }
}

enum ButtonsStrings: String {
    case cancelButton
    case removeButton
    case clearButton
    case addButton
    case saveButton
    case removeItemAlertTitle
    case removeItemAlertMessage
    case removeAllItemsAlertTitle
    case removeAllItemsAlertMessage
    
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "ButtonStrings")
    }
}

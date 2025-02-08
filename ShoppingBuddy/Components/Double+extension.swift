import Foundation

extension Double {
    func toCurrency(localeIdentifier: String = "pt_BR") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter.string(from: NSNumber(value: self)) ?? "R$ 0,00"
    }
}

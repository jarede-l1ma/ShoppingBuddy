import SwiftUI

extension View {
    /// Oculta o teclado virtual do sistema enviando uma ação de resignFirstResponder.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

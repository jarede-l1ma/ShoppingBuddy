import SwiftUI

struct TotalView: View {
    @Environment(ItemsStore.self) private var itemsStore
    
    var body: some View {
        Text(ItemRowStrings.purchaseTotal.localized + "\(Formatter.formatCurrency(itemsStore.totalPurchasePrice))")
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(10)
            )
            .padding(.horizontal, 10)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(ItemRowStrings.totalPurchaseValueLabel.localized)
            .accessibilityValue(Formatter.formatCurrency(itemsStore.totalPurchasePrice))
    }
}

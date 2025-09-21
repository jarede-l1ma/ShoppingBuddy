import SwiftUI

struct TotalView<Store: ItemsStoreProtocol>: View {
    @ObservedObject var itemsStore: Store
    
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
    }
}

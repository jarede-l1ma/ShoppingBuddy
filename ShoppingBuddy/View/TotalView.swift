import SwiftUI

struct TotalView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Text(ItemRowStrings.purchaseTotal.localized + "\(viewModel.formatCurrency(viewModel.totalPurchasePrice))")
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

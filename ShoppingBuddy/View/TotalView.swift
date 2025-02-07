import SwiftUI

struct TotalView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Text(ItemRowStrings.purchaseTotal.localized + "\(viewModel.formatCurrency(viewModel.totalPurchasePrice))")
            .font(.headline)
            .padding()
    }
}

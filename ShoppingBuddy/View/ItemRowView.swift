import SwiftUI

struct ItemRowView: View {
    @ObservedObject var viewModel: MainViewModel
    
    let item: Item
    let onTogglePurchased: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                Text(ItemRowStrings.quantity.localized + "\(item.quantity)")
                if item.unitPrice > 0 {
                    Text(ItemRowStrings.unitValue.localized + "\(formatCurrency(item.unitPrice))")
                    Text(ItemRowStrings.total.localized + "\(formatCurrency(item.totalPrice))")
                } else {
                    Text("R$ 0.00")
                }
            }
            Spacer()
            
            Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                .onTapGesture(perform: onTogglePurchased)
                .foregroundColor(item.isPurchased ? .green : .gray)
            
            Image(systemName: "pencil")
                .onTapGesture {
                    withAnimation(.easeIn) {
                        onEdit()
                    }
                }
            
            Image(systemName: "trash")
                .onTapGesture {
                    viewModel.confirmDeleteItem(item)
                }
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .padding(.horizontal)
        .background(
            item.isPurchased ? Color.green.opacity(0.1) : Color.clear
        )
        .cornerRadius(10)
        .shadow(radius: 2)
        .animation(.easeInOut, value: item.isPurchased)
        .contentShape(Rectangle())
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(
            from: NSNumber(value: value)
        ) ?? "R$ 0.00"
    }
}

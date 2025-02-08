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
                    .font(.headline)
                Text(ItemRowStrings.quantity.localized + "\(item.quantity)")
                    .font(.subheadline)
                if item.unitPrice > 0 {
                    Text(ItemRowStrings.unitValue.localized + "\(formatCurrency(item.unitPrice))")
                        .font(.subheadline)
                    Text(ItemRowStrings.total.localized + "\(formatCurrency(item.totalPrice))")
                        .font(.subheadline)
                } else {
                    Text(formatCurrency(0))
                        .font(.subheadline)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 75)
        .padding(.horizontal)
        .background(
            item.isPurchased ? Color.green.opacity(0.1) : Color.clear
        )
        .cornerRadius(10)
        .shadow(radius: 2)
        .animation(.easeInOut, value: item.isPurchased)
        .contentShape(Rectangle())
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button(action: {
                withAnimation {
                    onTogglePurchased()
                }
            }) {
                Label(ButtonsStrings.purchased.localized, systemImage: "checkmark.circle.fill")
                    .foregroundColor(.white)
            }
            .tint(item.isPurchased ? .gray : .green)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: {
                onDelete()
            }) {
                Label(ButtonsStrings.remove.localized, systemImage: "trash")
            }

            Button(action: {
                onEdit()
            }) {
                Label(ButtonsStrings.edit.localized, systemImage: "pencil")
                    .foregroundColor(.white)
            }
            .tint(.blue)
        }
    }

    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: value)) ?? "R$ 0,00"
    }
}

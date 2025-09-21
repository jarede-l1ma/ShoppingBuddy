import SwiftUI

struct HeaderView<FormViewModel: ItemFormViewModelProtocol, AlertsViewModel: AlertsViewModelProtocol>: View {
    @ObservedObject var formViewModel: FormViewModel
    @ObservedObject var alertsViewModel: AlertsViewModel
    
    var body: some View {
        VStack {
            Text(CommonsStrings.appName.localized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            HStack {
                Button(action: {
                    withAnimation {
                        formViewModel.showInputFields.toggle()
                    }
                }) {
                    Image(systemName: formViewModel.showInputFields ? "xmark" : "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12.5)
                        .background(formViewModel.showInputFields ? Color.red : Color.blue)
                        .cornerRadius(8, corners: .allCorners)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                if !formViewModel.showInputFields {
                    Button(action: {
                        alertsViewModel.showDeleteAllAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(8, corners: .allCorners)
                    }
                    .padding(.trailing, 20)
                }
            }
            .padding(.top, 10)
        }
    }
}

// MARK: - Preview

#Preview(traits: .sizeThatFitsLayout) {
    let store = ItemsStore(persistenceService: PersistenceService())
    let form = ItemFormViewModel(itemsStore: store)
    let alerts = AlertsViewModel(itemsStore: store)
    return HeaderView(formViewModel: form, alertsViewModel: alerts)
        .padding()
}

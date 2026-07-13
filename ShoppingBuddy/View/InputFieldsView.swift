import SwiftUI

struct InputFieldsView: View {
    @Environment(ItemFormViewModel.self) private var environmentFormVM
    
    var body: some View {
        @Bindable var formVM = environmentFormVM
        
        Group {
            if formVM.showInputFields {
                VStack {
                    TextField(TextfieldStrings.productName.localized, text: $formVM.newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            formVM.showDuplicateItemWarning ?
                            Text(TextfieldStrings.itemAlreadyExists.localized)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.red.opacity(0.9))
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                .offset(y: -25)
                                .transition(.scale.combined(with: .opacity))
                            : nil
                        )
                        .modifier(ShakeEffect(animatableData: CGFloat(formVM.showDuplicateItemWarning ? 1 : 0)))
                        .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: formVM.showDuplicateItemWarning)
                    
                    TextField(TextfieldStrings.quantityItem.localized, text: $formVM.newItemQuantity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            formVM.showInvalidQuantityWarning ?
                            Text(TextfieldStrings.itemQuantityInvalid.localized)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.red.opacity(0.9))
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                .offset(y: -25)
                                .transition(.scale.combined(with: .opacity))
                            : nil
                        )
                        .keyboardType(.numberPad)
                        .modifier(ShakeEffect(animatableData: CGFloat(formVM.showInvalidQuantityWarning ? 1 : 0)))
                        .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: formVM.showInvalidQuantityWarning)
                    
                    TextField(TextfieldStrings.unitValue.localized, text: $formVM.newItemUnitPrice)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    Picker(TextfieldStrings.section.localized, selection: $formVM.selectedSection) {
                        ForEach(Sections.allCases, id: \.self) { section in
                            Text(section.localized).tag(section)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    HStack {
                        Button(formVM.editingItem == nil ? ButtonsStrings.add.localized : ButtonsStrings.save.localized) {
                            formVM.editingItem == nil ? formVM.addItem() : formVM.updateItem()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Spacer()
                        
                        Button(action: { formVM.clearForm() }) {
                            Text(ButtonsStrings.clear.localized)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        if formVM.editingItem != nil {
                            Button(ButtonsStrings.cancel.localized) {
                                formVM.clearForm()
                                formVM.editingItem = nil
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                }
                .padding(.horizontal)
                .transition(.opacity.combined(with: .move(edge: Edge.top)))
            }
        }
    }
}

// MARK: - Preview

#Preview("InputFieldsView - Campos Visíveis") {
    let store = ItemsStore()
    let vm = ItemFormViewModel(itemsStore: store)
    vm.showInputFields = true
    vm.newItemName = "Abacate"
    vm.newItemQuantity = ""
    vm.newItemUnitPrice = "4.20"
    vm.selectedSection = .fruits
    vm.showInvalidQuantityWarning = true
    vm.invalidQuantityMessage = "Informe a quantidade!"
    return InputFieldsView()
        .environment(vm)
        .padding()
        .background(Color(.systemGroupedBackground))
}

import SwiftUI

struct InputFieldsView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Group {
            if viewModel.showInputFields {
                VStack {
                    TextField(TextfieldStrings.productName.localized, text: $viewModel.newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            viewModel.showDuplicateItemWarning ?
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
                        .modifier(ShakeEffect(animatableData: CGFloat(viewModel.showDuplicateItemWarning ? 1 : 0)))
                        .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: viewModel.showDuplicateItemWarning)
                    
                    TextField(TextfieldStrings.quantityItem.localized, text: $viewModel.newItemQuantity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    TextField(TextfieldStrings.unitValue.localized, text: $viewModel.newItemUnitPrice)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    Picker(TextfieldStrings.section.localized, selection: $viewModel.selectedSection) {
                        ForEach(Sections.allCases, id: \.self) { section in
                            Text(section.localized).tag(section)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    HStack {
                        Button(viewModel.editingItem == nil ? ButtonsStrings.add.localized : ButtonsStrings.save.localized) {
                            viewModel.editingItem == nil ? viewModel.addItem() : viewModel.updateItem()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        Spacer()
                        
                        Button(action: { viewModel.clearForm() }) {
                            Text(ButtonsStrings.clear.localized)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        if viewModel.editingItem != nil {
                            Button(ButtonsStrings.cancel.localized) {
                                viewModel.clearForm()
                                viewModel.editingItem = nil
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                    }
                }
                .padding(.horizontal)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

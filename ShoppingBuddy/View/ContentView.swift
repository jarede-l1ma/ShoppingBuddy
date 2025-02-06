import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            mainContentView
                .opacity(viewModel.isLoading ? 0 : 1)
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .alert(ButtonsStrings.removeItemAlertTitle.localized, isPresented: $viewModel.showDeleteAlert) {
            Button(ButtonsStrings.cancelButton.localized, role: .cancel) {
                viewModel.itemToDelete = nil
            }
            Button(ButtonsStrings.removeButton.localized, role: .destructive) {
                viewModel.deleteItem()
            }
        } message: {
            Text(ButtonsStrings.removeItemAlertMessage.localized)
        }
        .alert(ButtonsStrings.removeAllItemsAlertTitle.localized, isPresented: $viewModel.showDeleteAllAlert) {
            Button(ButtonsStrings.cancelButton.localized, role: .cancel) {}
            Button(ButtonsStrings.removeButton.localized, role: .destructive) {
                withAnimation {
                    viewModel.items.removeAll()
                    viewModel.saveItems()
                }
            }
        } message: {
            Text(ButtonsStrings.removeAllItemsAlertMessage.localized)
        }
    }
    
    private var mainContentView: some View {
        VStack {
            headerView
            inputFieldsView
            listView
                .padding(.top, 20)
            totalView
        }
    }
    
    private var headerView: some View {
        VStack {
            Text("ShoppingBuddy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.showInputFields.toggle()
                    }
                }) {
                    Image(systemName: viewModel.showInputFields ? "xmark" : "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(viewModel.showInputFields ? Color.red : Color.blue)
                        .cornerRadius(10)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                if !viewModel.showInputFields {
                    Button(action: {
                        viewModel.showDeleteAllAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                }
            }
            .padding(.top, 10)
        }
    }
    
    private var inputFieldsView: some View {
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
                                .offset(y: -45)
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
                        Button(viewModel.editingItem == nil ? ButtonsStrings.addButton.localized : ButtonsStrings.saveButton.localized) {
                            viewModel.editingItem == nil ? viewModel.addItem() : viewModel.updateItem()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        Spacer()
                        Button(action: { viewModel.clearForm() }) {
                            Text(ButtonsStrings.clearButton.localized)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        if viewModel.editingItem != nil {
                            Button(ButtonsStrings.cancelButton.localized) {
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
    
    private var listView: some View {
        List {
            ForEach(Sections.allCases, id: \.self) { section in
                sectionView(for: section)
            }
        }
        .animation(.easeInOut, value: viewModel.items)
    }
    
    private func sectionView(for section: Sections) -> some View {
        Section {
            if !viewModel.hiddenSections.contains(section) {
                ForEach(viewModel.items
                    .filter { $0.section == section }
                    .sorted(by: viewModel.sortItems), id: \.id) { item in
                        itemRow(for: item)
                    }
            }
        } header: {
            SectionHeaderView(
                section: section,
                isHidden: viewModel.hiddenSections.contains(section),
                onToggle: { viewModel.toggleSectionVisibility(section) }
            )
        }
    }
    
    private func itemRow(for item: Item) -> some View {
        ItemRowView(
            viewModel: viewModel,
            item: item,
            onTogglePurchased: { viewModel.togglePurchasedStatus(for: item)
            },
            onEdit: { viewModel.editItem(item) },
            onDelete: { viewModel.removeItem(item) }
        )
    }
    
    private func sortItems(_ lhs: Item, _ rhs: Item) -> Bool {
        lhs.name < rhs.name
    }
    
    private var totalView: some View {
        Text(ItemRowStrings.purchaseTotal.localized + "\(viewModel.formatCurrency(viewModel.totalPurchasePrice))")
            .font(.headline)
            .padding()
    }
}

import SwiftUI

struct ContentView: View {
    @Environment(ItemsStore.self) private var itemsStore
    @Environment(ItemFormViewModel.self) private var formVM
    @Environment(SectionsVisibilityViewModel.self) private var sectionsVM
    @Environment(AlertsViewModel.self) private var alertsVM
    
    @State private var biometricManager = BiometricManager()
    
    var body: some View {
        @Bindable var bindableAlertsVM = alertsVM
        
        NavigationView {
            ZStack {
                if biometricManager.isUnlocked {
                    mainContentView
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        Text(CommonsStrings.appLockedTitle.localized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(CommonsStrings.appLockedMessage.localized)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        if let error = biometricManager.errorDescription {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 10)
                        }
                        
                        Button(ButtonsStrings.tryAgain.localized) {
                            biometricManager.authenticate()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            biometricManager.authenticate()
        }
        .onChange(of: biometricManager.isUnlocked) { _, isUnlocked in
            if isUnlocked {
                itemsStore.loadInitialData()
            }
        }
        .alert(ButtonsStrings.removeAllItemsAlertTitle.localized, isPresented: $bindableAlertsVM.showDeleteAllAlert) {
            Button(ButtonsStrings.cancel.localized, role: .cancel) { }
            Button(ButtonsStrings.remove.localized, role: .destructive) {
                itemsStore.removeAllItems()
            }
        } message: {
            Text(ButtonsStrings.removeAllItemsAlertMessage.localized)
        }
        .alert(ButtonsStrings.removeItemAlertTitle.localized, isPresented: $bindableAlertsVM.showDeleteAlert) {
            Button(ButtonsStrings.cancel.localized, role: .cancel) { }
            Button(ButtonsStrings.remove.localized, role: .destructive) {
                alertsVM.deleteItem()
            }
        } message: {
            if let item = alertsVM.itemToDelete {
                Text(String(format: ButtonsStrings.removeItemAlertMessage.localized, item.name))
            }
        }
    }
    
    private var mainContentView: some View {
        VStack {
            HeaderView()
            if formVM.showInputFields {
                InputFieldsView()
                    .padding(.top, 20)
            }
            listView
            TotalView()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private var listView: some View {
        let sections = sectionsWithItems()
        
        return List {
            ForEach(Array(sections.enumerated()), id: \.element) { (idx, section) in
                sectionView(for: section, colorIndex: idx, total: sections.count)
            }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.interactively)
        .animation(.easeInOut, value: itemsStore.items)
    }
    
    private func sectionView(for section: Sections, colorIndex: Int, total: Int) -> some View {
        Section {
            if !sectionsVM.hiddenSections.contains(section) {
                ForEach(itemsStore.items
                    .filter { $0.section == section }
                    .sorted(by: itemsStore.sortItems), id: \.id) { item in
                        itemRow(for: item)
                    }
            }
        } header: {
            SectionView(
                section: section,
                color: SectionColors.colorForVisibleSection(at: colorIndex, total: total)
            )
            .padding(.horizontal, 16)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.automatic)
    }
    
    private func itemRow(for item: Item) -> some View {
        ItemRowView(item: item)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    
    private func sectionsWithItems() -> [Sections] {
        let sectionsWithContent = Sections.allCases.filter { section in
            itemsStore.items.contains { $0.section == section }
        }
        return sectionsWithContent.sorted {
            $0.localized.localizedCompare($1.localized) == .orderedAscending
        }
    }
}

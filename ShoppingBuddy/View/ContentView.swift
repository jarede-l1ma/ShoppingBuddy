import SwiftUI

struct ContentView: View {
    var itemsStore: ItemsStore
    var formVM: ItemFormViewModel
    var sectionsVM: SectionsVisibilityViewModel
    @Bindable var alertsVM: AlertsViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                mainContentView
                    .opacity(itemsStore.isLoading ? 0 : 1)
                
                if itemsStore.isLoading {
                    LoadingView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            itemsStore.loadInitialData()
        }
        .alert(ButtonsStrings.removeAllItemsAlertTitle.localized, isPresented: $alertsVM.showDeleteAllAlert) {
            Button(ButtonsStrings.cancel.localized, role: .cancel) { }
            Button(ButtonsStrings.remove.localized, role: .destructive) {
                itemsStore.removeAllItems()
            }
        } message: {
            Text(ButtonsStrings.removeAllItemsAlertMessage.localized)
        }
        .alert(ButtonsStrings.removeItemAlertTitle.localized, isPresented: $alertsVM.showDeleteAlert) {
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
            HeaderView(formViewModel: formVM, alertsViewModel: alertsVM)
            if formVM.showInputFields {
                InputFieldsView(formVM: formVM)
                    .padding(.top, 20)
            }
            listView
            TotalView(itemsStore: itemsStore)
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
                color: SectionColors.colorForVisibleSection(at: colorIndex, total: total),
                sectionsVM: sectionsVM
            )
            .padding(.horizontal, 16)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.automatic)
    }
    
    private func itemRow(for item: Item) -> some View {
        ItemRowView(
            itemsStore: itemsStore,
            formVM: formVM,
            item: item
        )
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

//
//  TilesEditListView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 01/06/2025.
//

import SwiftUI
import SwiftData

enum ListType {
    case filter(FilterType)
    case list(MyList)
}

struct EditListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.calendar) private var calendar
    @Binding var activeSheet: ListSheet?

    let container: ListsContainer
    
    @State private var pendingDelete: MyList?
    @State private var pendingDeleteSection: [MyList] = []
    @State private var pendingDeleteIndexes: IndexSet = []
    
    var body: some View {
        let rowHeight: CGFloat = 65
        let listHeight = (CGFloat(container.pinnedLists.count + container.unpinnedLists.count + container.pinnedFilters.count) * rowHeight) + rowHeight * 2
        
        List {
            if !container.pinnedFilters.isEmpty {
                Section(header: Text("Filters")) {
                    ForEach(container.pinnedFilters) { filter in
                        FilterRowEditView(filter: filter)
                    }
                    .onMove { source, destination in
                        container.moveFilters(from: source, to: destination)
                    }
                }
            }
            
            if !container.pinnedLists.isEmpty {
                Section(header: Text("Pinned Lists")) {
                    ForEach(container.pinnedLists) { list in
                        ListRowEditView(
                            myList: list,
                            onDelete: { },
                            onEdit: { activeSheet = .edit(list) },
                            onPinToggle: { container.togglePin(for: list) }
                        )
                    }
                    .onMove { source, destination in
                        container.movePinnedLists(from: source, to: destination)
                    }
                    .onDelete { indexes in
                        pendingDeleteSection = container.pinnedLists
                        pendingDeleteIndexes = indexes
                        if let firstIndex = indexes.first {
                            pendingDelete = container.pinnedLists[firstIndex]
                        }
                    }
                }
            }
            
            if !container.unpinnedLists.isEmpty {
                Section(header: Text("Unpinned Lists")) {
                    ForEach(container.unpinnedLists) { list in
                        ListRowEditView(
                            myList: list,
                            onDelete: { },
                            onEdit: { activeSheet = .edit(list) },
                            onPinToggle: { container.togglePin(for: list) }
                        )
                    }
                    .onMove { source, destination in
                        container.moveUnpinnedLists(from: source, to: destination)
                    }
                    .onDelete { indexes in
                        pendingDeleteSection = container.unpinnedLists
                        pendingDeleteIndexes = indexes
                        if let firstIndex = indexes.first {
                            pendingDelete = container.unpinnedLists[firstIndex]
                        }
                    }
                }
            }
        }
        .frame(height: listHeight)
        .scrollDisabled(true)
        .environment(\.editMode, .constant(container.isEditing ? .active : .inactive))
        .alert("Delete list?", isPresented: Binding(
            get: { pendingDelete != nil },
            set: { if !$0 { pendingDelete = nil } } //sprawdz
        )) {
            Button("Delete", role: .destructive) {
                handleConfirmedDelete()
            }
            Button("Cancel", role: .cancel) {
                pendingDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete \(pendingDelete?.name ?? "")? All reminders associated with this list will also be deleted.")
        }
    }
    
    private func handleConfirmedDelete() {
        pendingDeleteIndexes.forEach { index in
            let list = pendingDeleteSection[index]
            container.deleteList(list)
            modelContext.delete(list)
        }
        pendingDelete = nil
        pendingDeleteSection = []
        pendingDeleteIndexes = []
    }
}





struct EditListViewContainer: View {
    @State var activeSheet: ListSheet? = nil
    @State var selectedTile: ListTileModel? = nil
    let container = ListsContainer()

    var body: some View {
        EditListView(activeSheet: $activeSheet, container: container)
            .onAppear {
                container.refresh(with: SampleDataLists.myLists)
            }
            .onChange(of: SampleDataLists.myLists) {
                container.refresh(with: SampleDataLists.myLists)
            }
            .environment(container)
    }
}

#Preview { @MainActor in
    NavigationStack {
        EditListViewContainer()
    }
    .modelContainer(mockPreviewConteiner)
}

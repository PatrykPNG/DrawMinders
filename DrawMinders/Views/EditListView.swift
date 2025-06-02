//
//  TilesEditListView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 01/06/2025.
//

import SwiftUI
import SwiftData

struct EditListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.calendar) private var calendar
    @Binding var activeSheet: ListSheet?
    @Binding var selectedTile: ReminderTileModel?
    
    @Query private var allReminders: [Reminder]
    let container: ListsContainer
    
    private var filterTiles: [ReminderTileModel] {
        container.filterOrder.map { filter in
            TileFactory.createTile(for: filter, reminders: allReminders)
        }
    }
    
    private var pinnedListTiles: [ReminderTileModel] {
        container.pinnedLists.map { TileFactory.createTile(for: $0) }
    }
    
    private var unpinnedListTiles: [ReminderTileModel] {
        container.unpinnedLists.map { TileFactory.createTile(for: $0) }
    }
    
    var body: some View {
        let rowHeight: CGFloat = 65
        let listHeight = (CGFloat(filterTiles.count + pinnedListTiles.count + unpinnedListTiles.count) * rowHeight) + rowHeight
        
        List {
            Section("tiles and pinned lists") {
                ForEach(filterTiles) { tile in
                    tileRow(for: tile)
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                
                ForEach(pinnedListTiles) { tile in
                    tileRow(for: tile)
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .onMove { indices, destination in
                    container.movePinnedLists(from: indices, to: destination)
                }
            }
            
            Section("Unpinned lists") {
                ForEach(unpinnedListTiles) { tile in
                    tileRow(for: tile)
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                .onMove { indices, destination in
                    container.moveUnpinnedLists(from: indices, to: destination)
                }
            }
        }
        .frame(height: listHeight)
        .scrollDisabled(true)
        .environment(\.editMode, .constant(container.isEditing ? .active : .inactive))
    }
    
    private func tileRow(for tile: ReminderTileModel) -> some View {
        HStack(spacing: 12) {
            if case .list(let list) = tile.type {
                Button(role: .destructive) {
                    modelContext.delete(list)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(.white, .red)
                }
            }
            
            Image(systemName: tile.symbol)
                .font(.largeTitle)
                .foregroundStyle(.white, tile.symbolColor)
            
            Text(tile.title)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
            if case .list(let list) = tile.type {
                Button {
                    activeSheet = .edit(list)
                } label: {
                    Label("Edit list", systemImage: "info.circle")
                }
            }
        }
    }
}





struct EditListViewContainer: View {
    @State var activeSheet: ListSheet? = nil
    @State var selectedTile: ReminderTileModel? = nil
    let container = ListsContainer()

    var body: some View {
        EditListView(activeSheet: $activeSheet, selectedTile: $selectedTile, container: container)
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

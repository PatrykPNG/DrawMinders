//
//  TilesGrid.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 20/05/2025.
//

import SwiftUI
import SwiftData

struct TilesGrid: View {
    @Environment(\.calendar) private var calendar
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    
    @Query private var allReminders: [Reminder]
    
    @Binding var activeSheet: ListSheet?
    @Binding var selectedTile: ListTileModel?
    
    let container: ListsContainer
    
    //kolejnosc tiles w tym widoku
    private var tiles: [ListTileModel] {        
        return container.pinnedFilters
            .filter { $0.isVisible }
            .sorted(by: { $0.sortOrder < $1.sortOrder })
            .map { filter in
                TileFactory.createTile(for: filter.type, reminders: allReminders)
        } + container.pinnedLists.map { list in
            TileFactory.createTile(for: list)
        }
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(tiles) { tile in
                Button {
                    selectedTile = tile
                } label: {
                    ListTileView(
                        symbol: tile.symbol,
                        symbolColor: tile.symbolColor,
                        title: tile.title,
                        quantity: tile.count
                    )
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .contextMenu {
                    // dodac mozliwosc "ukrycia" wbudowanych kafelkow, zeby potem w edycji listy je przywrocic jak bedziemy chceili
                    if case .list(let myList) = tile.type {
                        Button {
                            myList.isPinned.toggle()
                        } label: {
                            Label(myList.isPinned ? "Unpin" : "Pin", systemImage: myList.isPinned ? "pin.slash" : "pin")
                        }
                        
                        Button(role: .destructive) {
                            deleteList(myList)
                        } label: {
                            Label("Delete list", systemImage: "trash")
                        }
                        
                        Button {
                            activeSheet = .edit(myList)
                        } label: {
                            Label("Edit list", systemImage: "info.circle")
                        }
                    } else if case .filter(let filterType) = tile.type {
                        if let pinnedFilter = container.pinnedFilters.first(where: { $0.type == filterType }) {
                            Button {
                                pinnedFilter.isVisible.toggle()
                            } label: {
                                Label(
                                    pinnedFilter.isVisible ? "Hide" : "Show",
                                    systemImage: pinnedFilter.isVisible ? "eye.slash" : "eye"
                                )
                            }
                        }
                    }
                }
                .transition(.identity)
            }
        }
        .padding(.horizontal)
        .animation(.snappy(duration: 0.25, extraBounce: 0), value: tiles)
    }
    
    private func deleteList(_ list: MyList) {
        container.deleteList(list)
        modelContext.delete(list)
    }
}




struct TilesGridContainer: View {
    @State var activeSheet: ListSheet? = nil
    @State var selectedTile: ListTileModel? = nil
    let container = ListsContainer()
    
    var body: some View {
        TilesGrid(activeSheet: $activeSheet, selectedTile: $selectedTile, container: container)
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
        TilesGridContainer()
    }
    .modelContainer(mockPreviewConteiner)
}

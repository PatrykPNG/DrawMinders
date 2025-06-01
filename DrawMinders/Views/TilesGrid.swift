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
    
    @Query(filter: #Predicate<MyList> { $0.isPinned }) private var pinnedLists: [MyList]
    @Query private var allReminders: [Reminder]
    
    @Binding var selectedTile: ReminderTileModel?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    private var tiles: [ReminderTileModel] {
        var tiles = [ReminderTileModel]()
        
        // trzeba dodac wbudowane filtry
        let filters: [FilterType] = [.today, .all, .planned, .flagged, .completed]
        
        for filter in filters {
            tiles.append(createTileForFilter(for: filter))
        }
        
        for list in pinnedLists {
            tiles.append(createTileForList(for: list))
        }
                
        return tiles
    }
    
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(tiles) { tile in
                Button {
                    selectedTile = tile
                } label: {
                    ReminderTileView(
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
                            modelContext.delete(myList)
                        } label: {
                            Label("Delete list", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .animation(.snappy(duration: 0.25, extraBounce: 0), value: tiles)
    }
    
    private func createTileForFilter(for filter: FilterType) -> ReminderTileModel {
            ReminderTileModel(
                symbol: filter.symbol,
                symbolColor: filter.symbolColor,
                title: filter.title,
                type: .filter(filter),
                count: countForFilter(filter)
            )
        }
        
        private func createTileForList(for list: MyList) -> ReminderTileModel {
            ReminderTileModel(
                symbol: list.symbol,
                symbolColor: Color(hex: list.hexColor),
                title: list.name,
                type: .list(list),
                count: list.reminders.count + list.sections.flatMap { $0.reminders }.count
            )
        }
        
    private func countForFilter(_ filter: FilterType) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else {
            return 0
        }
        
        switch filter {
        case .today:
            return allReminders.filter {
                guard let date = $0.reminderDate else { return false }
                return date >= today &&
                       date < tomorrow &&
                       !$0.isCompleted
            }.count
        case .all:
            return allReminders.count
        case .planned:
            return allReminders.filter {
                $0.reminderDate != nil &&
                !$0.isCompleted
            }.count
        case .flagged:
            return allReminders.filter {
                $0.isFlagged &&
                !$0.isCompleted
            }.count
        case .completed:
            return allReminders.filter {
                $0.isCompleted
            }.count
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        TilesGrid(selectedTile: .constant(nil))
    }
    .modelContainer(mockPreviewConteiner)
}

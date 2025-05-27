////
////  FilteredRemindersView.swift
////  DrawMinders
////
////  Created by Patryk Ostrowski on 24/05/2025.
////
//
//import SwiftUI
//import SwiftData
//
//struct FilteredRemindersView: View {
////    let title: String
////    let filter: (Reminder) -> Bool
////    
////    @Query private var reminders: [Reminder]
////    
////    @State private var selectedReminderId: PersistentIdentifier? = nil
////    
////    init(title: String, filter: @escaping (Reminder) -> Bool) {
////        self.title = title
////        self.filter = filter
////        _reminders = Query(filter: #Predicate { filter($0) })
////    }
//    
//    var body: some View {
//        Text("s")
////        List(reminders) { reminder in
////            ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
////        }
////        .navigationTitle(title)
//    }
//}
//
//
////
////  TilesGrid.swift
////  DrawMinders
////
////  Created by Patryk Ostrowski on 20/05/2025.
////
//
//import SwiftUI
//import SwiftData
//
//struct TilesGrid: View {
//    @Environment(\.calendar) private var calendar
//    @Environment(\.colorScheme) private var colorScheme
//    
//    @Query(filter: #Predicate<MyList> { $0.isPinned }) private var pinnedLists: [MyList]
//    
//    @Query private var allReminders: [Reminder]
//    
//    let columns = [GridItem(.flexible()), GridItem(.flexible())]
//    
//    private var tiles: [ReminderTileModel] {
//        var tiles = [ReminderTileModel]()
//        
//        // Kafelki for przypiete listy
//        for list in pinnedLists {
//            tiles.append(
//                ReminderTileModel(
//                    symbol: list.symbol,
//                    symbolColor: Color(hex: list.hexColor),
//                    title: list.name,
//                    type: .list(list),
//                    count: list.reminders.count
//                )
//            )
//        }
//        
//        // Kafelki dla kategori "wbudowanych"
//        tiles.append(contentsOf: [
//            ReminderTileModel(
//                symbol: "calendar.circle.fill",
//                symbolColor: .blue,
//                title: "Today",
//                type: .category(title: "Today") { reminder in
//                    Calendar.current.isDateInToday(reminder.reminderDate ?? Date()) && !reminder.isCompleted
//                },
//                count: allReminders.filter { $0.reminderDate != nil && Calendar.current.isDateInToday($0.reminderDate!) && !$0.isCompleted }.count
//            ),
//            
//            ReminderTileModel(
//                symbol: "tray.circle.fill",
//                symbolColor: colorScheme == .dark ? Color(.systemGray2) : Color.black,
//                title: "All",
//                type: .category(title: "All") { _ in true },
//                count: allReminders.count
//            ) //tutaj przecinek
//            
////            ReminderTileModel(
////                symbol: "flag.circle.fill",
////                symbolColor: <#T##Color#>,
////                title: <#T##String#>,
////                type: <#T##TileType#>,
////                count: <#T##Int#>
////            ),
////
////            ReminderTileModel(
////                symbol: "calendar.circle.fill",
////                symbolColor: <#T##Color#>,
////                title: <#T##String#>,
////                type: <#T##TileType#>,
////                count: <#T##Int#>
////            ),
////
////            ReminderTileModel(
////                symbol: "checkmark.circle.fill",
////                symbolColor: <#T##Color#>,
////                title: <#T##String#>,
////                type: <#T##TileType#>,
////                count: <#T##Int#>
////            ),
//        ])
//        
//        return tiles
//    }
//    
////    private var remindersForToday: [Reminder] {
////        let today = calendar.startOfDay(for: Date())
////        return reminders.filter {
////            guard let date = $0.reminderDate else { return false }
////            return calendar.isDate(date, inSameDayAs: today) && !$0.isCompleted
////        }
////    }
//
////    private var allReminders: [Reminder] {
////        reminders
////    }
////
////    private var flagedReminders: [Reminder] {
////        reminders.filter { $0.isFlagged && !$0.isCompleted }
////    }
////
////    private var plannedReminders: [Reminder] {
////        reminders.filter { $0.reminderDate != nil && !$0.isCompleted }
////    }
////
////    private var completedReminders: [Reminder] {
////        reminders.filter { !$0.isCompleted }
////    }
//    
//    var body: some View {
//        LazyVGrid(columns: columns, spacing: 16) {
//            ForEach(tiles) { tile in
//                NavigationLink {
//                    switch tile.type {
//                    case .list(let list):
//                        ListDetailScreen(myList: list)
//                    case .category(_, let filter):
//                        FilteredRemindersView(title: tile.title, filter: filter)
//                    }
//                } label: {
//                    ReminderTileView(
//                        symbol: tile.symbol,
//                        symbolColor: tile.symbolColor,
//                        title: tile.title,
//                        quantity: tile.count
//                    )
//                }
//                .buttonStyle(.plain)
//            }
////            ReminderTileView(symbol: "calendar.circle.fill", symbolColor: .blue, title: "Today", quantity: remindersForToday.count)
////                .onTapGesture {
////                    print("rem1")
////                }
////
////            ReminderTileView(symbol: "tray.circle.fill", symbolColor: colorScheme == .dark ? Color(.systemGray2) : Color.black, title: "All", quantity: allReminders.count)
////                .onTapGesture {
////                    print("tap 2")
////                }
////
////            ReminderTileView(symbol: "flag.circle.fill", symbolColor: .orange, title: "Flagged", quantity: flagedReminders.count)
////
////            ReminderTileView(symbol: "calendar.circle.fill", symbolColor: .red, title: "Planned", quantity: plannedReminders.count)
////
////            ReminderTileView(symbol: "checkmark.circle.fill", symbolColor: .gray, title: "Completed", quantity: completedReminders.count)
//            
//        }
////        .background(colorScheme == .dark ? Color(.black) : Color(.systemGray6))
//    }
//}
//
//#Preview { @MainActor in
//    NavigationStack {
//        TilesGrid()
//    }
//    .modelContainer(mockPreviewConteiner)
//}

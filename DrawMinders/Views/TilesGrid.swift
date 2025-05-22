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
    
    @Query private var reminders: [Reminder]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    private var remindersForToday: [Reminder] {
        let today = calendar.startOfDay(for: Date())
        return reminders.filter {
            guard let date = $0.reminderDate else { return false }
            return calendar.isDate(date, inSameDayAs: today) && !$0.isCompleted
        }
    }

    private var allReminders: [Reminder] {
        reminders
    }

    private var flagedReminders: [Reminder] {
        reminders.filter { $0.isFlagged && !$0.isCompleted }
    }
    
    private var plannedReminders: [Reminder] {
        reminders.filter { $0.reminderDate != nil && !$0.isCompleted }
    }

    private var completedReminders: [Reminder] {
        reminders.filter { !$0.isCompleted }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ReminderTileView(symbol: "calendar.circle.fill", symbolColor: .blue, title: "Today", quantity: remindersForToday.count)
                .onTapGesture {
                    print("rem1")
                }
            
            ReminderTileView(symbol: "tray.circle.fill", symbolColor: colorScheme == .dark ? Color(.systemGray2) : Color.black, title: "All", quantity: allReminders.count)
                .onTapGesture {
                    print("tap 2")
                }
            
            ReminderTileView(symbol: "flag.circle.fill", symbolColor: .orange, title: "Flagged", quantity: flagedReminders.count)
            
            ReminderTileView(symbol: "calendar.circle.fill", symbolColor: .red, title: "Planned", quantity: plannedReminders.count)
            
            ReminderTileView(symbol: "checkmark.circle.fill", symbolColor: .gray, title: "Completed", quantity: completedReminders.count)
            
        }
        .background(colorScheme == .dark ? Color(.black) : Color(.systemGray6))
    }
}

#Preview { @MainActor in
    NavigationStack {
        TilesGrid()
    }
    .modelContainer(mockPreviewConteiner)
}

//
//  TodayRemindersView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/05/2025.
//

import SwiftUI
import SwiftData

struct TodayRemindersView: View {
    @Query private var reminders: [Reminder]
    @State private var selectedReminderId: PersistentIdentifier? = nil
    
    private var remindersForToday: [Reminder] {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            return reminders.filter {
                guard let date = $0.reminderDate else { return false }
                return date >= today && date < tomorrow && !$0.isCompleted
            }
        }
    
    var body: some View {
        List(remindersForToday) { reminder in
            ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
        }
        .navigationTitle("Today")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.plain)
        .listRowSeparator(.hidden)
    }
}


#Preview { @MainActor in
    NavigationStack {
        TodayRemindersView()
    }
    .modelContainer(mockPreviewConteiner)
}

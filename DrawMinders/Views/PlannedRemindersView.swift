//
//  PlannedRemindersView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/05/2025.
//

import SwiftUI
import SwiftData

struct PlannedRemindersView: View {
    
    @Query(filter: #Predicate<Reminder> { $0.reminderDate != nil && !$0.isCompleted })  private var reminders: [Reminder]
    
    @State private var selectedReminderId: PersistentIdentifier? = nil
    
    var body: some View {
        List(reminders) { reminder in
            ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
        }
        .navigationTitle("Planned")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.plain)
        .listRowSeparator(.hidden)
    }
}

#Preview { @MainActor in
    NavigationStack {
        PlannedRemindersView()
    }
    .modelContainer(mockPreviewConteiner)
}

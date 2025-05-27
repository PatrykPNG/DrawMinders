//
//  FlaggedremindersView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/05/2025.
//

import SwiftUI
import SwiftData

struct FlaggedRemindersView: View {
    
    @Query(filter: #Predicate<Reminder> { $0.isFlagged })  private var reminders: [Reminder]
    
    @State private var selectedReminderId: PersistentIdentifier? = nil
    
    var body: some View {
        if reminders.isEmpty {
            Text("0 reminders")
                .foregroundStyle(.secondary)
        } else {
            List(reminders) { reminder in
                ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
            }
            
            .navigationTitle("Flagged")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(.plain)
            .listRowSeparator(.hidden)
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        FlaggedRemindersView()
    }
    .modelContainer(mockPreviewConteiner)
}


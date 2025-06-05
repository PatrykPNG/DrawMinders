//
//  AllRemindersView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/05/2025.
//

import SwiftUI
import SwiftData

struct AllRemindersView: View {
    @Query private var lists: [MyList]
    
    @State private var selectedReminderId: PersistentIdentifier? = nil
    
    
    var body: some View {
        List {
            ForEach(lists) { list in
                let allReminders = list.allReminders
                if !allReminders.isEmpty {
                    Section(
                        header:
                            Text(list.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                                .foregroundStyle(Color(hex: list.hexColor))
                    ) {
                        ForEach(allReminders) { reminder in
//                            ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId, onTextChange: { _ in })
                        }
                    }
                }
            }
        }
        .navigationTitle("All Reminders")
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.plain)
        
    }
}

#Preview { @MainActor in
    NavigationStack {
        AllRemindersView()
    }
    .modelContainer(mockPreviewConteiner)
}

extension MyList {
    var allReminders: [Reminder] {
        sections.flatMap { $0.reminders } + reminders
    }
}

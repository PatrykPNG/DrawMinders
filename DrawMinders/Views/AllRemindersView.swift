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
                if !list.reminders.isEmpty {
                    Section(
                        header:
                            Text(list.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .fontDesign(.rounded)
                                .foregroundStyle(Color(hex: list.hexColor))
                    ) {
                        ForEach(list.reminders) { reminder in
                            ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
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

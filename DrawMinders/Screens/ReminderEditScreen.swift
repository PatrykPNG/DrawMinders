//
//  ReminderEditScreen.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 20/05/2025.
//

import SwiftUI
import SwiftData

struct ReminderEditScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
        
    @Bindable var reminder: Reminder
    
    @State private var editTitle: String = ""
    @State private var editNotes: String = ""
    @State private var editDate: Date = .now
    @State private var editTime: Date = .now
    
    @State private var hasDate: Bool = false
    @State private var hasTime: Bool = false
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $editTitle)
                TextField("Notes", text: $editNotes)
            }
            
            Section {
                Toggle("Date", isOn: $hasDate)
                if hasDate {
                    DatePicker("Date", selection: $editDate, displayedComponents: .date)
                }
                
                Toggle("Hour", isOn: $hasTime)
                if hasTime {
                    DatePicker("Hour", selection: $editTime, displayedComponents: .hourAndMinute)
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    save()
                    dismiss()
                }
                .disabled(editTitle.isEmpty)
            }
        }
        .onAppear {
            editTitle = reminder.title
            editNotes = reminder.notes ?? ""
            if let date = reminder.reminderDate {
                editDate = date
                hasDate = true
            } else {
                hasDate = false
            }
            if let time = reminder.reminderTime {
                editTime = time
                hasTime = true
            } else {
                hasTime = false
            }
        }
        .onChange(of: hasTime, {
            hasDate = true
        })
    }
    
    private func save() {
        reminder.title = editTitle
        reminder.notes = editNotes.isEmpty ? nil : editNotes
        reminder.reminderDate = hasDate ? editDate : nil
        reminder.reminderTime = hasTime ? editTime : nil
    }
}

struct ReminderEditScreenContainer: View {
    
    @Query(sort: \Reminder.title) private var reminders: [Reminder]
    
    var body: some View {
        ReminderEditScreen(reminder: reminders[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        ReminderEditScreenContainer()
    }
    .modelContainer(mockPreviewConteiner)
}

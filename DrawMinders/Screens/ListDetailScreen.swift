//
//  ListDetailScreen.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 19/05/2025.
//

import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct ListDetailScreen: View {

    @Environment(\.modelContext) private var modelContext

    @Bindable var myList: MyList
    @State private var reminderTitle: String = ""
    @State private var isReminderAlertPresented: Bool = false
    @State private var selectedReminderId: PersistentIdentifier? = nil
    

    // .filter { !$0.isCompleted }
var body: some View {
    VStack {
        List(myList.reminders) { reminder in
            ReminderRowView(
                reminder: reminder,
                selectedReminderId: $selectedReminderId
            )
            .swipeActions {
                Button(role: .destructive) {
                    deleteReminder(reminder)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.plain)
        .listRowSeparator(.hidden)

        Spacer()

        Button {
            isReminderAlertPresented = true
        } label: {
            Image(systemName: "plus.circle.fill")
            Text("Reminder")
                .foregroundStyle(.blue)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        }
        .navigationTitle(myList.name)
        .navigationBarTitleDisplayMode(.large)
        .alert("New Reminder", isPresented: $isReminderAlertPresented) {
            TextField("reminder title", text: $reminderTitle)
            Button("Cancel", role: .cancel) { }
            Button("Save") {
                let reminder = Reminder(title: reminderTitle)
                myList.reminders.append(reminder)
                reminderTitle = ""
            }
        }
    }
    
    private func deleteReminder(_ reminder: Reminder) {
        modelContext.delete(reminder)
        try? modelContext.save()
    }
}



struct MyListDetailScreenContainer: View {

    @Query private var myLists: [MyList]

    var body: some View {
        ListDetailScreen(myList: myLists[0])
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListDetailScreenContainer()
    }
    .modelContainer(mockPreviewConteiner)
}

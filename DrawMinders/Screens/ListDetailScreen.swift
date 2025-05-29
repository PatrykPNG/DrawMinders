//
//  ListDetailScreen.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 19/05/2025.
//

import SwiftUI
import SwiftData

//    ReminderRowView(
//        reminder: reminder,
//        selectedReminderId: $selectedReminderId
//    )
//    .swipeActions {
//        Button(role: .destructive) {
//            deleteReminder(reminder)
//        } label: {
//            Label("Delete", systemImage: "trash")
//        }
//    }


struct ListDetailScreen: View {

    @Environment(\.modelContext) private var modelContext

    @Bindable var myList: MyList
    @State private var reminderTitle: String = ""
    @State private var isReminderAlertPresented: Bool = false
    @State private var selectedReminderId: PersistentIdentifier? = nil
    
    @State private var newSectionID: UUID?
    @FocusState private var focusedSectionID: UUID?
    

    var body: some View {
        List {
            if !myList.reminders.isEmpty {
                ForEach(myList.reminders) { reminder in
                    ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
                }
            }
            
            ForEach(myList.sections.filter { !$0.isDefault }) { section in
                Section {
                    ForEach(section.reminders) { reminder in
                        ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
                    }
                } header: {
                    EditableSectionHeader(
                        section: section,
                        onDelete: { deleteSection(section) }
                    )
                    .focused($focusedSectionID, equals: section.uuid)
                }
            }
            
            if let inneSection = myList.sections.first(where: { $0.isDefault }) {
                Section {
                    ForEach(inneSection.reminders) { reminder in
                        ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
                    }
                } header: {
                    Text("Inne")
                }
            }
        }
        .onChange(of: myList.sections) {
            validateInneSection()
        }
        .onChange(of: newSectionID) {
            if let id = newSectionID {
                focusedSectionID = id
            }
        }
        .navigationTitle(myList.name)
        .navigationBarTitleDisplayMode(.large)
        .listStyle(.plain)
        
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    addSection()
                } label: {
                    Text("add section")
                }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    addReminder()
                } label: {
                    Image(systemName: "plus.circle.fill")
                    Text("Reminder")
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }
                Spacer()
            }
        }
    }
    
    private func deleteReminder(_ reminder: Reminder) {
        // Przed usunięciem przypomnienia, usuń je z sekcji
        if let section = reminder.section {
            section.reminders.removeAll { $0.id == reminder.id }
        } else {
            myList.reminders.removeAll { $0.id == reminder.id }
        }
        
        modelContext.delete(reminder)
        try? modelContext.save()
    }
    
    private func addReminder() {
        let newReminder = Reminder(title: "Nowe przypomnienie")
        
        // Logika przypisywania
        if let inne = myList.sections.first(where: { $0.isDefault }) {
            inne.reminders.append(newReminder)
            newReminder.section = inne
        } else {
            myList.reminders.append(newReminder)
        }
        
        modelContext.insert(newReminder)
        try? modelContext.save()
    }
    
    private func addSection() {
        let newSection = ReminderSection(title: "", isTemporary: true)
        newSectionID = newSection.uuid
        myList.sections.insert(newSection, at: 0)
        
        // Utwórz "Inne" jeśli nie istnieje
        if myList.sections.first(where: { $0.isDefault }) == nil {
            let defaultSection = ReminderSection(title: "Inne", isDefault: true)
            myList.sections.append(defaultSection)
        }
        
        // Przenieś istniejące przypomnienia do "Inne"
        moveOrphansToInne()
    }
    
    private func deleteSection(_ section: ReminderSection) {
        guard !section.isDefault else { return }
        
        // Przenieś przypomnienia do "Inne"
        if let inne = myList.sections.first(where: { $0.isDefault }) {
            inne.reminders.append(contentsOf: section.reminders)
            section.reminders.forEach { $0.section = inne }
        }
        
        modelContext.delete(section)
        myList.sections.removeAll { $0.id == section.id }
        validateInneSection()
        try? modelContext.save() // natychmiastowo aktualizacja
    }
    
    private func moveOrphansToInne() {
        guard let inne = myList.sections.first(where: { $0.isDefault }) else { return }
        
        // Przenieś tylko przypomnienia bez sekcji
        let orphans = myList.reminders.filter { $0.section == nil }
        inne.reminders.append(contentsOf: orphans)
        myList.reminders.removeAll { orphans.contains($0) }
    }
    
    private func validateInneSection() {
        guard let inne = myList.sections.first(where: { $0.isDefault }) else { return }
        
        // Sprawdź czy są jakiekolwiek NIEDOMYŚLNE sekcje
        let hasUserSections = myList.sections.contains { !$0.isDefault }
        
        if !hasUserSections {
            // Przenieś przypomnienia z powrotem do głównej listy
            myList.reminders.append(contentsOf: inne.reminders)
            inne.reminders.forEach { $0.section = nil }
            
            // Usuń "Inne"
            modelContext.delete(inne)
            myList.sections.removeAll { $0.isDefault }
            try? modelContext.save()
        }
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



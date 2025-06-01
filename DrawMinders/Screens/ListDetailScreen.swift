//
//  ListDetailScreen.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 19/05/2025.
//

import SwiftUI
import SwiftData

struct ListDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme

    @Bindable var myList: MyList
    @State private var reminderTitle: String = ""
    @State private var isReminderAlertPresented: Bool = false
    @State private var selectedReminderId: PersistentIdentifier? = nil
    @State private var newSectionID: UUID?
    @State private var isInneSectionExpanded: Bool = true
    @FocusState private var focusedSectionID: UUID?
    

    var body: some View {
        List {
            if !myList.reminders.isEmpty {
                ForEach(myList.reminders) { reminder in
                    ReminderRowView(
                        reminder: reminder,
                        selectedReminderId: $selectedReminderId
                    )
                    .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
                }
            }
            
            ForEach(myList.sections.filter { !$0.isDefault }) { section in
                ExpandableSectionView(
                    section: section,
                    onDelete: { deleteSection(section) },
                    selectedReminderId: $selectedReminderId,
                    focusedSectionID: $focusedSectionID
                )
                .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
            }
            
            if let inneSection = myList.sections.first(where: { $0.isDefault }) {
                Section(isExpanded: $isInneSectionExpanded) {
                    ForEach(inneSection.reminders) { reminder in
                        ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
                            .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
                    }
                } header: {
                    Text("Inne")
                        .font(.title3)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
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
        .contentMargins(.horizontal, 0)
        .scrollContentBackground(.hidden)
        .listStyle(.sidebar)
        
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    addSection()
                } label: {
                    Text("add section")
                }
                .disabled(disableSectionButton())
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
        // Przed usunieciem przypomnienia, usun je z sekcji
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
    
    private func disableSectionButton() -> Bool {
        myList.sections.contains { $0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
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





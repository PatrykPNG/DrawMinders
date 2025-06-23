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
    @Environment(\.scenePhase) private var scenePhase
    

    @Bindable var myList: MyList
    @State private var isReminderAlertPresented: Bool = false
    @State private var selectedReminderId: PersistentIdentifier? = nil
    @State private var tempSection: TempSection? = nil
    @State private var isEditingTempSection = false
    
    @State private var othersSectionName: String = ""

    private var remindersWithoutSection: [Reminder] {
        myList.reminders.filter { $0.section == nil }
    }

    var body: some View {
  
        
        ScrollView {
            LazyVStack {
                // Tutaj tymczasowa sekcja
                if let tempSection = tempSection {
                    Divider()
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.separator))

                    TempSectionRow(
                        section: tempSection,
                        onCommit: confirmTempSection,
                        onCancel: cancelTempSection
                    )
                    .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
                }
                
                // Przypadki gdy nie ma sekcji
                if myList.sections.isEmpty {
                    remindersWithoutSectionBlock
                }
                // Przypadki gdy są sekcje
                else {
                    sectionsBlock
                    
                    // Dodatkowe przypomnienia bez sekcji (gdy istnieją)
                    if !remindersWithoutSection.isEmpty {
                        OthersSection(
                            reminders: remindersWithoutSection,
                            onDelete: deleteAllRemindersWithoutSection,
                            selectedReminderId: $selectedReminderId,
                            sectionName: $othersSectionName,
                            onCreate: createSectionFromOthers
                        )
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.horizontal)
        .navigationTitle(myList.name)
        .navigationBarTitleDisplayMode(.large)
        .contentMargins(.horizontal, 0)
        .scrollContentBackground(.hidden)
//        .listStyle(.sidebar)
        .onDisappear {
            autoSaveTempSection()
            autoSaveOthersSection()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                autoSaveTempSection()
                autoSaveOthersSection()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add section") {
                    addSection()
                }
                .disabled(tempSection != nil)
            }
            
            ToolbarItem(placement: .bottomBar) {
                    Button(action: addReminder) {
                        Image(systemName: "plus.circle.fill")
                    }
            }
        }
    }
    
    private var remindersWithoutSectionBlock: some View {
        ForEach(remindersWithoutSection) { reminder in
            ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
            Divider()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.separator))
                .padding(.leading, 30)
        }
        .padding(.leading)
        .padding(.top)
        .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
    }
    
    private var sectionsBlock: some View {
        ForEach(myList.sections.sorted(by: { $0.sortOrder < $1.sortOrder })) { section in
            ExpandableSectionView(
                section: section,
                onDelete: { deleteSection(section) },
                selectedReminderId: $selectedReminderId
            )
            Divider()
                .frame(height: 2)
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.separator))
        }
    }
    
    private func addSection() {
        tempSection = TempSection()
        isEditingTempSection = true
    }
    
    private func addReminder() {
        let reminder = Reminder( list: myList)
        myList.reminders.append(reminder)
    }
    
    private func deleteSection(_ section: ReminderSection) {
        modelContext.delete(section)
        try? modelContext.save()
    }
    
    private func deleteAllRemindersWithoutSection() {
        print("Usuwanie wszystkich przypomnień bez sekcji...")
        remindersWithoutSection.forEach { reminder in
            print("Usuwam: \(reminder.title)")
            modelContext.delete(reminder)
        }
        do {
            try modelContext.save()
            print("Zapisano zmiany pomyślnie")
        } catch {
            print("Błąd zapisu: \(error.localizedDescription)")
        }
    }
    
    private func confirmTempSection() {
        guard let tempSection = tempSection else { return }
        guard !tempSection.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            cancelTempSection()
            return
        }
        
        let newSection = ReminderSection(
            title: tempSection.title,
            sortOrder: myList.sections.count,
            list: myList
        )
        
        withAnimation {
            myList.sections.append(newSection)
            self.tempSection = nil
        }
    }
    
    private func cancelTempSection() {
        withAnimation {
            tempSection = nil
        }
    }
    
    private func autoSaveTempSection() {
        guard let tempSection = tempSection else { return }
        
        if !tempSection.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            confirmTempSection()
        } else {
            cancelTempSection()
        }
    }
    
    private func createSectionFromOthers() {
        let title = othersSectionName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        
        let newSection = ReminderSection(
            title: title,
            sortOrder: myList.sections.count,
            list: myList
        )
        
        remindersWithoutSection.forEach { $0.section = newSection }
        
        
        withAnimation {
            myList.sections.append(newSection)
            
            DispatchQueue.main.async {
                othersSectionName = ""
                modelContext.processPendingChanges()
            }
        }
    }
    
    private func autoSaveOthersSection() {
        guard !othersSectionName.isEmpty else { return }
        createSectionFromOthers()
    }
}



@MainActor
var previewContainer: ModelContainer = {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MyList.self, Reminder.self, ReminderSection.self, configurations: config)
    let list = SampleDataLists.previewList
    container.mainContext.insert(list)
    return container
}()

#Preview { @MainActor in
    NavigationStack {
        ListDetailScreen(myList: SampleDataLists.previewList)
    }
    .modelContainer(previewContainer)
}






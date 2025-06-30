//
//  SwiftUIView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 29/05/2025.
//

import SwiftUI
import SwiftData

struct ExpandableSectionView: View {
    @EnvironmentObject private var dragState: DragState
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Bindable var section: ReminderSection
    let onDelete: () -> Void
    @Binding var selectedReminderId: PersistentIdentifier?

    @State private var isTargeted: Bool = false
  
    var body: some View {
        ZStack {
            VStack {
                DisclosureGroup(
                    isExpanded: $section.isExpanded, // Use the model property
                    content: {
                        SectionContentView(
                            section: section,
                            selectedReminderId: $selectedReminderId,
                            isTargeted: $isTargeted
                        )
                    },
                    label: {
                        EditableSectionHeader(
                            section: section,
                            onDelete: onDelete
                        )
                    }
                )
            }
            
            if dragState.shouldHighlight(for: section.uuid) {
                DropTargetOverlay(isTargeted: isTargeted)
                    .allowsHitTesting(true)
                    .zIndex(1)
                    .dropDestination(for: Data.self) { droppedData, location in
                        handleSectionDrop(droppedData: droppedData)
                    } isTargeted: { targeted in
                        withAnimation {
                            self.isTargeted = targeted
                        }
                    }
            }
        }
    }
        
    private func handleSectionDrop(droppedData: [Data]) -> Bool {
        guard
            let data = droppedData.first,
            let uuidString = String(data: data, encoding: .utf8),
            let uuid = UUID(uuidString: uuidString),
            let reminder = fetchReminder(by: uuid)
        else {
            print("DROP: Failed to parse drop data")
            return false
        }
        
        let oldSection = reminder.section
 
        if let oldSection = oldSection {
            oldSection.reminders.removeAll { $0.uuid == reminder.uuid }
        }
        
        reminder.section = section
        section.reminders.append(reminder)
        
        dragState.reset()
        
        do {
            try modelContext.save()
            print("DROP: ModelContext saved successfully")
            
            // Force SwiftData to process changes
            DispatchQueue.main.async {
                modelContext.processPendingChanges()
            }
            
            return true
        } catch {
            print("DROP: Save failed: \(error)")
            return false
        }
    }


    
    private func fetchReminder(by uuid: UUID) -> Reminder? {
        let predicate = #Predicate<Reminder> { $0.uuid == uuid }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try? modelContext.fetch(descriptor).first
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var selectedReminderId: PersistentIdentifier? = nil
        @StateObject private var dragState = DragState()
        
        let section: ReminderSection = {
            let section = ReminderSection(title: "Testowa sekcja")
            let reminder1 = Reminder(title: "Przypomnienie 1")
            let reminder2 = Reminder(title: "Przypomnienie 2")
            section.reminders = [reminder1, reminder2]
            return section
        }()
        
        var body: some View {
            ExpandableSectionView(
                section: section,
                onDelete: {},
                selectedReminderId: $selectedReminderId
            )
            .environmentObject(dragState)
        }
    }
    
    return PreviewWrapper()
}




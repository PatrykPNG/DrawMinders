//
//  SectionContentView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/06/2025.
//

import SwiftUI
import SwiftData

struct SectionContentView: View {
    @EnvironmentObject private var dragState: DragState
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Bindable var section: ReminderSection
    @Binding var selectedReminderId: PersistentIdentifier?
    @Binding var isTargeted: Bool
    
    let rowHeight: CGFloat = 95
    var listHeight: CGFloat {
        CGFloat(section.reminders.count) * rowHeight
    }

    var body: some View {
        let shouldHighlight = isTargeted && dragState.activeDragSource != section.uuid
        ZStack(alignment: .top) {
            
            List {
                ForEach(section.reminders) { reminder in
                    ReminderRowView(
                        reminder: reminder,
                        selectedReminderId: $selectedReminderId,
                        sectionId: section.uuid
                    )
                }
                .onMove { indices, newOffset in
                    section.reminders.move(fromOffsets: indices, toOffset: newOffset)
                }
            }
            .frame(height: listHeight)
            .scrollDisabled(true)
            .listStyle(.plain)
            .background(colorScheme == .dark ? Color.black : Color.white)
            
            Color.clear
                .background(shouldHighlight ? Color.gray.opacity(0.3) : .clear)
                .contentShape(Rectangle())
                .frame(height: listHeight)
                .allowsHitTesting(isTargeted && dragState.activeDragSource != section.uuid)
                .zIndex(1)
                .dropDestination(for: Data.self) { droppedData, location in
                    handleDrop(droppedData: droppedData)
                } isTargeted: { isTargeted in
                   
                        self.isTargeted = isTargeted
                  
                }
        }
    }
    
    private func handleDrop(droppedData: [Data]) -> Bool {
        guard
            let data = droppedData.first,
            let uuidString = String(data: data, encoding: .utf8),
            let uuid = UUID(uuidString: uuidString),
            let reminder = fetchReminder(by: uuid)
        else { return false }
        
        reminder.section = section
        dragState.reset()
        
        do {
            try modelContext.save()
            return true
        } catch {
            print("Błąd zapisu: \(error)")
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
        @State private var isTargeted: Bool = false
        @FocusState private var focusedSectionID: UUID?
        
        let section: ReminderSection = {
            let section = ReminderSection(title: "Testowa sekcja")
            let reminder1 = Reminder(title: "Przypomnienie 1")
            let reminder2 = Reminder(title: "Przypomnienie 2")
            section.reminders = [reminder1, reminder2]
            return section
        }()
        
        var body: some View {
            SectionContentView(
                section: section,
                selectedReminderId: $selectedReminderId,
                isTargeted: $isTargeted
            )
        }
    }
    
    return PreviewWrapper()
}

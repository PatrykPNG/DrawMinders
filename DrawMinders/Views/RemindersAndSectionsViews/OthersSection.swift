//
//  OthersSection.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 10/06/2025.
//

import SwiftUI

import SwiftUI
import SwiftData

struct OthersSection: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    let reminders: [Reminder]
    let onDelete: () -> Void
    @Binding var selectedReminderId: PersistentIdentifier?
    @Binding var sectionName: String
    var onCreate: () -> Void
    
    @State private var isExpanded: Bool = true
    
    @State private var isTargeted: Bool = false

    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                ForEach(reminders) { reminder in
                    ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
                }
            },
            label: {
                HStack {
                    TextField("Others", text: $sectionName, onCommit: onCreate)
                        .font(.headline)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .submitLabel(.done)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical)
                .contentShape(Rectangle())
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete All", systemImage: "trash")
                    }
                }
                .onChange(of: reminders) {
                    if reminders.isEmpty {
                        sectionName = ""
                    }
                }
            }
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(
                  colorScheme == .dark ?
                  (isTargeted ? Color.gray.opacity(0.3) : Color.black) :
                  (isTargeted ? Color.gray.opacity(0.1) : Color.white)
              )
        )
        .dropDestination(for: Data.self) { droppedData, location in
            for data in droppedData {
                guard
                    let uuidString = String(data: data, encoding: .utf8),
                    let uuid = UUID(uuidString: uuidString),
                    let reminder = fetchReminder(by: uuid)
                else { continue }
                
                // Ustaw sekcję na nil, aby przypomnienie trafiło do "Others"
                reminder.section = nil
            }
            
            do {
                try modelContext.save()
                return true
            } catch {
                print("Błąd zapisu: \(error)")
                return false
            }
        } isTargeted: { isTargeted in
            withAnimation {
                self.isTargeted = isTargeted
            }
        }
    }
    
    private func fetchReminder(by uuid: UUID) -> Reminder? {
       let predicate = #Predicate<Reminder> { $0.uuid == uuid }
       let descriptor = FetchDescriptor(predicate: predicate)
       return try? modelContext.fetch(descriptor).first
   }
}

#Preview {
    @Previewable @State var selectedReminderId: PersistentIdentifier? = nil
    @Previewable @State var sectionName: String = "Testcsc"
    let reminders = SampleDataLists.reminders

    return OthersSection(
        reminders: reminders,
        onDelete: {},
        selectedReminderId: $selectedReminderId,
        sectionName: .constant("egtyawu"),
        onCreate: {}
    )
    .modelContainer(mockPreviewConteiner)
}

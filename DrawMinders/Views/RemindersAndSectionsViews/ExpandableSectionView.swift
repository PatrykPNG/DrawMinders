//
//  SwiftUIView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 29/05/2025.
//

import SwiftUI
import SwiftData

struct ExpandableSectionView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Bindable var section: ReminderSection
    let onDelete: () -> Void
    @Binding var selectedReminderId: PersistentIdentifier?

    @State private var isExpanded: Bool = true
    
    @State private var isTargeted: Bool = false

    var body: some View {
        VStack {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    Button("delete section") {
                        onDelete()
                    }
                    .buttonStyle(.bordered)
                    ForEach(section.reminders) { reminder in
                        ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
                        Divider()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.separator))
                            .padding(.leading, 30)
                    }
                },
                label: {
                    EditableSectionHeader(
                        section: section,
                        onDelete: onDelete
                    )
                }
            )
        }
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
            guard
                let data = droppedData.first, // pobierz dane
                let uuidString = String(data: data, encoding: .utf8), // konwertuj na String
                let uuid = UUID(uuidString: uuidString), // konwertuj na UUID
                let reminder = fetchReminder(by: uuid) // znajdz w bazie
            else { return false }
            
            reminder.section = section // zaktualizuj sekcje
            
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
    struct PreviewWrapper: View {
        @State private var selectedReminderId: PersistentIdentifier? = nil
        @FocusState private var focusedSectionID: UUID?
        
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
        }
    }
    
    return PreviewWrapper()
}

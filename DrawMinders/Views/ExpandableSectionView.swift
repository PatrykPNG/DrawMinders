//
//  SwiftUIView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 29/05/2025.
//

import SwiftUI
import SwiftData

struct ExpandableSectionView: View {
    let section: ReminderSection
    let onDelete: () -> Void
    @Binding var selectedReminderId: PersistentIdentifier?
    @FocusState.Binding var focusedSectionID: UUID?

    @State private var isExpanded: Bool = true

    var body: some View {
        Section(isExpanded: $isExpanded) {
            ForEach(section.reminders) { reminder in
                ReminderRowView(reminder: reminder, selectedReminderId: $selectedReminderId)
            }
        } header: {
            EditableSectionHeader(
                section: section,
                onDelete: onDelete
            )
            .focused($focusedSectionID, equals: section.uuid)
        }
    }
}




#Preview {
    struct PreviewWrapper: View {
        @State private var selectedReminderId: PersistentIdentifier? = nil
        @FocusState private var focusedSectionID: UUID?
        
        let section: ReminderSection = {
            let section = ReminderSection(title: "Testowa sekcja", isTemporary: false, isDefault: false)
            let reminder1 = Reminder(title: "Przypomnienie 1")
            let reminder2 = Reminder(title: "Przypomnienie 2")
            section.reminders = [reminder1, reminder2]
            return section
        }()
        
        var body: some View {
            List {
                ExpandableSectionView(
                    section: section,
                    onDelete: {},
                    selectedReminderId: $selectedReminderId,
                    focusedSectionID: $focusedSectionID
                )
            }
            .listStyle(.sidebar)
        }
    }
    
    return PreviewWrapper()
}

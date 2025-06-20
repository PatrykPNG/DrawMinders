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
    let reminders: [Reminder]
    let onDelete: () -> Void
    @Binding var selectedReminderId: PersistentIdentifier?
    @Binding var sectionName: String
    var onCreate: () -> Void
    
    @State private var isExpanded: Bool = true

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
        .padding(.leading)
        .listRowBackground(colorScheme == .dark ? Color.black : Color.white)
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

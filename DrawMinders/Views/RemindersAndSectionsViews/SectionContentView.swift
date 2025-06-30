//
//  SectionContentView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/06/2025.
//

import SwiftUI
import SwiftData

struct SectionContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Bindable var section: ReminderSection
    @Binding var selectedReminderId: PersistentIdentifier?
    @Binding var isTargeted: Bool
    
    private let rowHeight: CGFloat = 44.0
    var listHeight: CGFloat {
        CGFloat(section.reminders.count) * rowHeight
    }

    var body: some View {
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
            .listRowInsets(EdgeInsets())
        }
        .frame(height: listHeight)
        .scrollDisabled(true)
        .listStyle(.plain)
        .background(colorScheme == .dark ? Color.black : Color.white)
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




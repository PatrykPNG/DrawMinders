//
//  SectionDropOverlay.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 25/06/2025.
//

import SwiftUI
import SwiftData

struct SectionDropOverlay: View {
    let section: ReminderSection
    @ObservedObject var dragState: DragState
    @Environment(\.modelContext) private var modelContext
    
    @State private var isTargeted: Bool = false
    @State private var sectionFrame: CGRect = .zero
    
    var body: some View {
        GeometryReader { geometry in
            // Position overlay over specific section
            DropTargetOverlay(isTargeted: isTargeted)
                .frame(width: geometry.size.width - 24, height: estimatedSectionHeight)
                .position(x: geometry.size.width / 2, y: getSectionPosition())
                .allowsHitTesting(true)
                .dropDestination(for: Data.self) { droppedData, location in
                    print("🎯 Global overlay drop for section: \(section.title)")
                    return handleSectionDrop(droppedData: droppedData)
                } isTargeted: { targeted in
                    withAnimation {
                        self.isTargeted = targeted
                    }
                }
        }
    }
    
    private var estimatedSectionHeight: CGFloat {
        let headerHeight: CGFloat = 50
        let contentHeight = section.isExpanded ? CGFloat(section.reminders.count * 60) : 0
        return headerHeight + contentHeight
    }
    
    private func getSectionPosition() -> CGFloat {
        // Calculate approximate Y position based on section order
        let sectionIndex = section.sortOrder
        let approximateY = CGFloat(sectionIndex) * estimatedSectionHeight + estimatedSectionHeight / 2
        return approximateY
    }
    
    private func handleSectionDrop(droppedData: [Data]) -> Bool {
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
            print("Error saving: \(error)")
            return false
        }
    }
    
    private func fetchReminder(by uuid: UUID) -> Reminder? {
        let predicate = #Predicate<Reminder> { $0.uuid == uuid }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try? modelContext.fetch(descriptor).first
    }
}

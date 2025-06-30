//
//  DragState.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/06/2025.
//

import SwiftUI

class DragState: ObservableObject {
    @Published var activeDragSource: UUID?
    @Published var isDragging: Bool = false
    @Published var draggedReminderId: UUID?
    
    func setSource(_ id: UUID, reminderId: UUID? = nil) {
        activeDragSource = id
        draggedReminderId = reminderId
        isDragging = true
    }
    
    func reset() {
        activeDragSource = nil
        draggedReminderId = nil
        isDragging = false
    }
}

extension DragState {
    func shouldHighlight(for sectionId: UUID) -> Bool {
        isDragging && activeDragSource != sectionId
    }
}

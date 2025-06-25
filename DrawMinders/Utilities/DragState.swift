//
//  DragState.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/06/2025.
//

import SwiftUI

class DragState: ObservableObject {
    @Published var activeDragSource: UUID?
    
    func setSource(_ id: UUID) {
        activeDragSource = id
    }
    
    func reset() {
        activeDragSource = nil
    }
}

extension DragState {
    func shouldHighlight(for sectionId: UUID) -> Bool {
        activeDragSource != sectionId
    }
}

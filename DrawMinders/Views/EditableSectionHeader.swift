//
//  EditableSectionHeader.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 27/05/2025.
//

import SwiftUI
import SwiftData

struct EditableSectionHeader: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var section: ReminderSection
    var onDelete: () -> Void
    
    @FocusState private var isFocused: Bool
    
    @State private var tempTitle: String = ""
    
    var body: some View {
        HStack {
            TextField("Nazwa sekcji", text: $tempTitle)
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .focused($isFocused)
                .onSubmit {
                    if tempTitle.isEmpty {
                        onDelete()
                    } else {
                        section.isTemporary = false
                    }
                }
                .onChange(of: tempTitle) {
                    section.title = tempTitle
                }
                .onAppear {
                    tempTitle = section.title
                    if section.isTemporary {
                        isFocused = true
                    }
                }
                
            
            if !section.isDefault {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.plain)
            }
        }
    }
    
}

#Preview { @MainActor in
    let section = ReminderSection(title: "Testowa sekcja", isTemporary: false)
    return EditableSectionHeader(
        section: section,
        onDelete: {}
    )
    .modelContainer(mockPreviewConteiner)
}

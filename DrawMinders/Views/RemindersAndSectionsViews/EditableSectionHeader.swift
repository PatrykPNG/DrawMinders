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
    @State private var editedTitle: String = ""
    @State private var originalTitle: String = ""
    
    var body: some View {
        HStack {
            TextField("Nazwa sekcji", text: $editedTitle)
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .multilineTextAlignment(.leading)
                .focused($isFocused)
                .onSubmit(validateTitle)
                .onAppear {
                    editedTitle = section.title
                    originalTitle = section.title
                }
                .onChange(of: isFocused) { _, newValue in
                    if !newValue {
                        validateTitle()
                    }
                }
            
            Spacer()
            Button("delete section") {
                onDelete()
            }
            .buttonStyle(.bordered)
            Spacer()
            
            Text("boze")
        }
        .padding(.vertical)
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func validateTitle() {
        let trimmed = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            editedTitle = originalTitle
        } else if trimmed != section.title {
            section.title = trimmed
        }
    }
    
}

#Preview { @MainActor in
    let section = ReminderSection(title: "Testowa sekcja")
    return EditableSectionHeader(
        section: section,
        onDelete: {}
    )
    .modelContainer(mockPreviewConteiner)
}

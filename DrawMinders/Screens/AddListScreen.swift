//
//  AddListScreen.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import SwiftUI
import SwiftData

struct AddListScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var existingList: MyList?
    
    @State private var selectedSymbol: String
    @State private var selectedColor: Color
    @State private var listName: String
    
    init(existingList: MyList? = nil) {
        self.existingList = existingList
        
        _selectedSymbol = State(initialValue: existingList? .symbol ?? "list.bullet.circle.fill")
        _selectedColor = State(initialValue: Color(hex: existingList?.hexColor ?? "#007AFF"))
        _listName = State(initialValue: existingList? .name ?? "")
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Image(systemName: selectedSymbol)
                        .font(.system(size: 75))
                        .foregroundStyle(.white, selectedColor)
                        .shadow(radius: 10)
                    
                    TextField("List title", text: $listName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 55)
                }
            }
            
            Section {
                ColorSelectionView(selectedColor: $selectedColor)
            }
            
            Section {
                SymbolSelectionView(selectedSymbol: $selectedSymbol)
            }
        }
        .navigationTitle("New list")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
                
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    save()
                }
                .disabled(listName.isEmpty)
            }
        }
    }
    
    private func save() {
        if let existingList {
            existingList.name = listName
            existingList.hexColor = selectedColor.toHexString() ?? "#007AFF"
            existingList.symbol = selectedSymbol
        } else {
            let newList = MyList(
                name: listName,
                hexColor: selectedColor.toHexString() ?? "#007AFF",
                symbol: selectedSymbol
            )
            modelContext.insert(newList)
        }
        
        try? modelContext.save()
        dismiss()
    }
}

#Preview { @MainActor in
    NavigationStack {
        AddListScreen()
    }
    .modelContainer(mockPreviewConteiner)
}

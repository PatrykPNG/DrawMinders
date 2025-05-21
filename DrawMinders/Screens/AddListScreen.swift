//
//  AddListView.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import SwiftUI

struct AddListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedSymbol: String = "list.bullet.circle.fill"
    @State private var selectedColor: Color = .blue
    @State private var listName = ""
    
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
                SFSymbolSelection(selectedSymbol: $selectedSymbol)
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
                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Done") {
//                        let myList = MyList(name: listName)
//                        context.insert(myList)
//                        dismiss()
//                    }
//                }
            }
    }
}

#Preview {
    NavigationStack {
        AddListView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

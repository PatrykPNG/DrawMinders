//
//  AddListView.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import SwiftUI

struct AddListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var listName = ""
    
    var body: some View {
        VStack {
            TextField("List title", text: $listName)
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
                        let list = MyList(name: $listName)
                        context.insert(list)
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        AddListView()
            .modelContainer(SampleData.shared.modelContainer)
    }
}

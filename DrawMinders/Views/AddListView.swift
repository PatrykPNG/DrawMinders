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

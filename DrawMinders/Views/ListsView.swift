//
//  listsView.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import SwiftUI

struct listsView: View {
    let lists = ["domowe", "cwiczenia", "zakupy"]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            
            ForEach(lists, id: \.self) { list in
                HStack {
                    Image(systemName: "line.3.horizontal.circle.fill")
                    
                    Text(list)
                }
            }
            
            //ten buutton poirtem chyba w toolbar
            Button {
                isPresented = true
            } label: {
                Text("add list")
                    .foregroundStyle(.blue)
            }

        }
        .listStyle(.plain)
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AddListView()
            }
        }
    }
}

#Preview {
    listsView()
}

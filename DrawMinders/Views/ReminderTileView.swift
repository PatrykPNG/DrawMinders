//
//  ReminderTileView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 20/05/2025.
//

import SwiftUI

struct ReminderTileView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let symbol: String
    let symbolColor: Color
    let title: String
    let quantity: Int
    
    var body: some View {
        VStack() {
            HStack {
                Image(systemName: symbol)
                    .font(.title)
                    .foregroundStyle(.white, symbolColor)
                
                Spacer()
                
                Text("\(quantity)")
                    .font(.title2.bold())
                
            }
            
            Spacer()
            HStack {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
        }
        .padding(10)
        .background(colorScheme == .dark ? Color(.systemGray6) : Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 2)
    }
}

#Preview {
    ReminderTileView(symbol: "calendar.circle.fill", symbolColor: Color(.red), title: "Today", quantity: 5)
}

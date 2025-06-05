//
//  ColorSelectionView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 19/05/2025.
//

import SwiftUI

struct ColorSelectionView: View {
    
    @Binding var selectedColor: Color
    
    let colors: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple, .brown, .pink, .indigo, .gray, .mint]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Circle()
                        .strokeBorder(selectedColor.toHexString() == color.toHexString() ? .gray : .clear, lineWidth: 3)
                        .scaleEffect(CGSize(width: 1.2, height: 1.2))
                        
                    Circle().fill()
                        .foregroundStyle(color)
                        .padding(2)
                }
                .onTapGesture {
                    selectedColor = color
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity ,maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}


#Preview {
    ColorSelectionView(selectedColor: .constant(.blue))
}

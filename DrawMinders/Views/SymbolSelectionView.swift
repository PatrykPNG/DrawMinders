//
//  SFSymbolSelection.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 19/05/2025.
//

import SwiftUI

struct SFSymbolSelection: View {
    
    @Binding var selectedSymbol: String
    
    let symbols: [String] = ["list.bullet.circle.fill", "tag.circle.fill", "microphone.circle.fill", "sos.circle.fill", "camera.circle.fill", "dog.circle.fill", "envelope.circle.fill", "scissors.circle.fill", "cart.circle.fill", "shoe.circle.fill", "theatermasks.circle.fill", "mappin.circle.fill", "toilet.circle.fill", "tram.circle.fill", "leaf.circle.fill", "shippingbox.circle.fill", "gamecontroller.circle.fill", "gift.circle.fill"]
    
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
            ForEach(symbols, id: \.self) { symbol in
                ZStack {
                    Circle()
                        .strokeBorder(selectedSymbol == symbol ? .gray : .clear, lineWidth: 3)
                        .scaleEffect(CGSize(width: 1.2, height: 1.2))
                        
                    
                    Image(systemName: symbol)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white.opacity(0.9), Color(.systemGray2))
                        .padding(2)
                }
                .onTapGesture {
                    selectedSymbol = symbol
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.gray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        
    }
}

#Preview {
    SFSymbolSelection(selectedSymbol: .constant("tag.circle.fill"))
}

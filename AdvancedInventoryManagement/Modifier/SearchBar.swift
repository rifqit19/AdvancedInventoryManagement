//
//  SearchBar.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 19/12/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: (String) -> Void
    
    var body: some View {
        HStack {
            TextField("Search location", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .shadow(radius: 1)
                .onSubmit {
                    onSearch(text)
                }
            
            Button(action: {
                onSearch(text)
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(8)
                    .background(.orangeFF7F13)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

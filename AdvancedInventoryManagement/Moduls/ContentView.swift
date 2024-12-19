//
//  ContentView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 12/12/24.
//

import SwiftUI

// User interfase for dasboard
struct ContentView: View {
    var body: some View {
        TabView {
            InventoryView()
                .tabItem {
                    Label("Inventory", systemImage: "doc.text")
                }
            
            SupplierView()
                .tabItem {
                    Label("Supplier", systemImage: "list.dash")
                }
            
        }
    }
}

#Preview {
    ContentView()
}

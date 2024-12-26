//
//  ContentView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 12/12/24.
//

import SwiftUI

// User interfase for dasboard
struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var supplierViewModel = SupplierViewModel()
    @StateObject private var itemViewModel = ItemViewModel()

    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                TabView {
                    SupplierView()
                        .tabItem {
                            Label("Supplier", systemImage: "list.dash")
                        }
                        .environmentObject(supplierViewModel)
                        .environmentObject(itemViewModel)

                    ItemListView()
                        .tabItem {
                            Label("Inventory", systemImage: "doc.text")
                        }.environmentObject(itemViewModel)
                    
                    
                    AccountView()
                        .tabItem {
                            Label("Account", systemImage: "person")
                        }

                }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}

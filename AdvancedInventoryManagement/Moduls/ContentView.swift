//
//  ContentView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 12/12/24.
//

import SwiftUI

// User interfase for dasboard
struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabView {
                    ItemListView()
                        .tabItem {
                            Label("Inventory", systemImage: "doc.text")
                        }

        //            InventoryView()
        //                .tabItem {
        //                    Label("Inventory", systemImage: "doc.text")
        //                }
                    
                    SupplierView()
                        .tabItem {
                            Label("Supplier", systemImage: "list.dash")
                        }
                    
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

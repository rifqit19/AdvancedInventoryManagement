//
//  InventoryView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import SwiftUI

struct InventoryView: View {
    // Dummy data for inventory items
    @State private var inventoryItems: [Inventory] = [
        Inventory(id: "1", name: "Laptop", quantity: 10, supplierID: "1", supplierName: "Tech Supplies Inc."),
        Inventory(id: "2", name: "Office Chair", quantity: 5, supplierID: "2", supplierName: "Furniture Co."),
        Inventory(id: "3", name: "Projector", quantity: 2, supplierID: "1", supplierName: "Tech Supplies Inc."),
        Inventory(id: "4", name: "Desk Lamp", quantity: 8, supplierID: "3", supplierName: "Office Needs")
    ]

    var body: some View {
        NavigationView {
            List(inventoryItems) { item in
                HStack(spacing: 8) {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 50)
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("Quantity: \(item.quantity)")
                            .font(.subheadline)
                        Text("Supplier: \(item.supplierName)")
                            .font(.footnote)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Add Item action")
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    InventoryView()
}

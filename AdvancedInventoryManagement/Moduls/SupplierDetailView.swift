//
//  SupplierDetailView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import SwiftUI

struct SupplierDetailView: View {
    let supplier: Supplier
    let inventoryItems: [Inventory]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(supplier.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Address: \(supplier.address)")
                        .font(.title2)

                    Text("Contact: \(supplier.contact)")
                        .font(.body)

                    Button(action: {
                        openGoogleMaps(lat: supplier.latitude, lng: supplier.longitude)
                    }) {
                        Text("View Location on Map")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Divider()

                    Section(header: Text("Inventory Items")) {
                        ForEach(inventoryItems.filter { $0.supplierID == supplier.id }) { item in
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
                                }
                            }
                        }

                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Supplier Details")
                .hideTabBar()
            }
        }
        
    }

    func openGoogleMaps(lat: Double, lng: Double) {
        let urlString = "http://maps.google.com/?q=\(lat),\(lng)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
#Preview {
    var sample =  Supplier(
        id: "1",
        name: "Tech Supplies Inc.",
        address: "123 Tech Street",
        contact: "+123456789",
        latitude: 37.7749,
        longitude: -122.4194)

    var inventoryItems: [Inventory] = [
        Inventory(id: "1", name: "Laptop", quantity: 10, supplierID: "1", supplierName: "Tech Supplies Inc."),
        Inventory(id: "3", name: "Projector", quantity: 2, supplierID: "1", supplierName: "Tech Supplies Inc.")
    ]

    SupplierDetailView(supplier: sample, inventoryItems: inventoryItems)
}

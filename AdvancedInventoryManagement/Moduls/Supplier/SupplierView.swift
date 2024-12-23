//
//  SupplierView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import SwiftUI

struct SupplierView: View {
    // Dummy data for suppliers
    @State private var suppliers: [Supplier2] = [
        Supplier2(id: "1", name: "Tech Supplies Inc.", address: "123 Tech Street", contact: "+123456789", latitude: 37.7749, longitude: -122.4194),
        Supplier2(id: "2", name: "Furniture Co.", address: "456 Home Ave", contact: "+987654321", latitude: 34.0522, longitude: -118.2437),
        Supplier2(id: "3", name: "Office Needs", address: "789 Office Blvd", contact: "+1122334455", latitude: 40.7128, longitude: -74.0060)
    ]

    // Dummy data for inventory items
    @State private var inventoryItems: [Inventory] = [
        Inventory(id: "1", name: "Laptop", quantity: 10, supplierID: "1", supplierName: "Tech Supplies Inc."),
        Inventory(id: "2", name: "Office Chair", quantity: 5, supplierID: "2", supplierName: "Furniture Co."),
        Inventory(id: "3", name: "Projector", quantity: 2, supplierID: "1", supplierName: "Tech Supplies Inc."),
        Inventory(id: "4", name: "Desk Lamp", quantity: 8, supplierID: "3", supplierName: "Office Needs")
    ]
    
    @EnvironmentObject var viewModel: SupplierViewModel
    
    var body: some View {
        NavigationView {
            ZStack{
                
                if viewModel.suppliers.isEmpty{
                    VStack {
                        Spacer()
                        
                        Image(systemName: "folder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("Tidak ada supplier")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Tambahkan supplier dengan menekan tombol +")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Spacer()
                    }

                } else {
                    List(viewModel.suppliers) { supplier in
                        NavigationLink(destination: SupplierDetailView(supplier: supplier, inventoryItems: inventoryItems)) {
                            VStack(alignment: .leading) {
                                Text(supplier.name)
                                    .font(.headline)
                                Text(supplier.address)
                                    .font(.subheadline)
                                Text("Contact: \(supplier.contact)")
                                    .font(.footnote)
                            }
                            .padding(.vertical, 5)
                        }
                    }

                }
            }
            .navigationTitle("Suppliers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddSupplierView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchSuppliers() // Fetch data saat view muncul
                }
            }
            .showTabBar()
        }
        
    }
}

#Preview {
    SupplierView()
}

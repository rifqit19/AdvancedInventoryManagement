//
//  SupplierView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import SwiftUI

struct SupplierView: View {
    
    @EnvironmentObject var viewModel: SupplierViewModel
    @State private var selectedSupplier: Supplier? = nil
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationView {
            ZStack{
                
                if viewModel.suppliers.isEmpty {
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
                        NavigationLink(destination: SupplierDetailView(supplier: .constant(supplier))) {
                            VStack(alignment: .leading) {
                                Text(supplier.name)
                                    .font(.headline)
                                Text(supplier.address)
                                    .font(.subheadline)
                                Text("Contact: \(supplier.contact)")
                                    .font(.footnote)
                            }
                            .padding(.vertical, 5)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteSupplier(supplierID: supplier.id ?? "")
                                    }
                                } label: {
                                    Label("Hapus", systemImage: "trash")
                                }
                                
                                Button {
                                    selectedSupplier = supplier
                                    isEditing = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
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
                    await viewModel.fetchSuppliers() 
                }
            }
            .showTabBar()
            .background(
                NavigationLink(
                    destination: EditSupplierView(supplier: selectedSupplier ?? Supplier(id: "", userID: "", name: "", address: "", contact: "", longitude: 0.0, latitude: 0.0)),
                    isActive: $isEditing
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
        
    }
}

#Preview {
    SupplierView()
}

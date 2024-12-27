//
//  SupplierDetailView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import SwiftUI
import MapKit

struct SupplierDetailView: View {
    @Binding var supplier: Supplier
    
    @ObservedObject var itemViewModel = ItemViewModel()
    @State private var region: MKCoordinateRegion
    @EnvironmentObject var supplierViewModel: SupplierViewModel

    @Environment(\.dismiss) var dismiss

    init(supplier: Binding<Supplier>) {
        self._supplier = supplier
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: supplier.wrappedValue.latitude, longitude: supplier.wrappedValue.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Text("Details of Supplier")
                        .font(.title2)
                        .bold()
                    Spacer()
                }

                Text(supplier.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text("Address: \(supplier.address)")
                    .font(.title2)

                Text("Contact: \(supplier.contact)")
                    .font(.body)

                ZStack {
                    Map(coordinateRegion: $region, annotationItems: [supplier]) { location in
                        MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(true)
                    
                    Button(action: {
                        openGoogleMaps(lat: supplier.latitude, lng: supplier.longitude)
                    }) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .contentShape(Rectangle())
                    }
                }
                
                Text("Lat: \(supplier.latitude), Long: \(supplier.longitude)")
                    .font(.body)

                HStack {
                    Button(action: {
                        Task {
                            await supplierViewModel.deleteSupplier(supplierID: supplier.id ?? "")
                            dismiss()
                        }
                    }) {
                        Text("Delete Supplier")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }

                    NavigationLink(destination: EditSupplierView(supplier: supplier).onDisappear(perform: {
                        itemViewModel.fetchItems(for: supplier.id ?? "")
                    })) {
                        Text("Edit Supplier")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                .padding(.vertical)

                Divider()

                Section {
                    HStack {
                        Text("Inventory Items")
                        Spacer()
                        NavigationLink(destination: AddItemView(supplierID: supplier.id ?? "", supplierName: supplier.name)) {
                            Image(systemName: "plus")
                        }
                    }
                    
                    if itemViewModel.items.isEmpty {
                        Text("No items available.")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        ForEach(itemViewModel.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                HStack(alignment: .top, spacing: 16) {
                                    if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 60, height: 60)
                                                .cornerRadius(8)
                                                .shadow(radius: 2)
                                        } placeholder: {
                                            ProgressView()
                                                .frame(width: 60, height: 60)
                                        }
                                    } else {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                            .overlay(Text("No Image").font(.caption).foregroundColor(.gray))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(item.name)
                                            .font(.headline)
                                            .lineLimit(1)
                                        
                                        Text("Price: Rp.\(item.price, specifier: "%.2f")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        Text("Stock: \(item.stock)")
                                            .font(.subheadline)
                                            .foregroundColor(item.stock > 0 ? .green : .red)
                                        
                                        Text("Category: \(item.category)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .onAppear {
                itemViewModel.fetchItems(for: supplier.id ?? "")
            }
            .onChange(of: supplier) { newSupplier in
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: newSupplier.latitude, longitude: newSupplier.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                
            }
            .hideTabBar()
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
        userID: "1",
        name: "Tech Supplies Inc.",
        address: "123 Tech Street",
        contact: "+123456789",
        longitude: -122.4194,
        latitude: 37.7749)

    SupplierDetailView(supplier: .constant(sample))
}

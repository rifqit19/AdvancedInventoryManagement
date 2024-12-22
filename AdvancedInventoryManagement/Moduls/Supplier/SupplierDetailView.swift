//
//  SupplierDetailView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import SwiftUI
import MapKit

struct SupplierDetailView: View {
    let supplier: Supplier
    let inventoryItems: [Inventory]
    

    @State private var region: MKCoordinateRegion

    init(supplier: Supplier, inventoryItems: [Inventory]) {
        self.supplier = supplier
        self.inventoryItems = inventoryItems
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: supplier.latitude, longitude: supplier.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack{
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

                    ZStack{
                        // buatkan mapview
                        
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

                    Divider()

                    Section {
                        HStack {
                            Text("Inventory Items")
                            Spacer()
//                            NavigationLink(destination: AddSupplierView()) {
//                                Image(systemName: "plus")
//                            }
                            
                            Button {
                                print("add item")
                            } label: {
                                Image(systemName: "plus")
                            }


                        }
                        
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

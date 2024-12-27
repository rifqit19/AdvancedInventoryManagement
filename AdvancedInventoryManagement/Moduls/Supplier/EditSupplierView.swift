//
//  EditSupplierView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 27/12/24.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct EditSupplierView: View {
    
    @State var supplier: Supplier
    @State private var isShowingMapPicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var mapRegion: MKCoordinateRegion

    @EnvironmentObject private var supplierViewModel: SupplierViewModel
    @Environment(\.dismiss) var dismiss
    
    init(supplier: Supplier) {
        self._supplier = State(initialValue: supplier)
        self._mapRegion = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: supplier.latitude, longitude: supplier.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                Text("Edit Supplier")
                    .font(.title2)
                    .bold()
                
                TextField("Name", text: $supplier.name)
                    .TextFieldTitleStyle(title: "Name", placeholder: "Supplier Name", text: $supplier.name)
                
                TextField("Address", text: $supplier.address)
                    .TextFieldTitleStyle(title: "Address", placeholder: "Supplier Address", text: $supplier.address)
                
                TextField("Contact", text: $supplier.contact)
                    .TextFieldTitleStyle(title: "Contact", placeholder: "Supplier Contact", text: $supplier.contact)
                
                Section(header: Text("Location")) {
                    
                    if supplier.latitude != 0.0 && supplier.longitude != 0.0 {
                        Button("Change Location") {
                            isShowingMapPicker = true
                        }
                        
                        Text("Coordinates: \(supplier.latitude), \(supplier.longitude)")
                        
                        Map(coordinateRegion: $mapRegion, annotationItems: [
                            AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: supplier.latitude, longitude: supplier.longitude))
                        ]) { annotation in
                            MapMarker(coordinate: annotation.coordinate, tint: .red)
                        }
                        .frame(height: 200)
                        .cornerRadius(10)
                        .disabled(true)

                        
                    } else {
                        Button("Get Location") {
                            isShowingMapPicker = true
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    updateSupplier()
                } label: {
                    Text("Update")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 50,
                                style: .continuous
                            )
                            .fill(.blue)
                        )
                }
            }
            .padding(20)
            .hideTabBar()
            .sheet(isPresented: $isShowingMapPicker) {
                MapPickerView(
                    latitude: $supplier.latitude,
                    longitude: $supplier.longitude,
                    isPresented: $isShowingMapPicker
                )
            }
            .onChange(of: supplier.latitude) { newValue in
                mapRegion.center.latitude = newValue
            }
            .onChange(of: supplier.longitude) { newValue in
                mapRegion.center.longitude = newValue
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - Update Supplier
    private func updateSupplier() {
        guard !supplier.name.isEmpty,
              !supplier.address.isEmpty,
              !supplier.contact.isEmpty,
              supplier.latitude != 0.0,
              supplier.longitude != 0.0 else {
            alertMessage = "Please fill in all fields and select a location."
            showAlert = true
            return
        }
        
        Task {
            do {
                await supplierViewModel.updateSupplier(supplier: supplier)
                mapRegion.center = CLLocationCoordinate2D(latitude: supplier.latitude, longitude: supplier.longitude) // Update Map
                dismiss()
            } catch {
                alertMessage = "Failed to update supplier."
                showAlert = true
            }
        }
    }
}

#Preview {
    EditSupplierView(supplier: Supplier(
        id: "sampleID",
        userID: "sampleUserID",
        name: "Sample Supplier",
        address: "123 Sample Address",
        contact: "123-456-789",
        longitude: 103.851959,
        latitude: 1.290270
    ))
    .environmentObject(SupplierViewModel())
}

//
//  AddSupplierView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import Foundation
import SwiftUI
import MapKit
import FirebaseAuth

struct AddSupplierView: View {
    
    @State private var name = ""
    @State private var address = ""
    @State private var contact = ""
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    @State private var isShowingMapPicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @StateObject private var supplierViewModel = SupplierViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                Text("Add Supplier")
                    .font(.title2)
                    .bold()
                
                TextField("Name", text: $name)
                    .TextFieldTitleStyle(title: "Nama", placeholder: "Name", text: $name)
                
                TextField("Address", text: $address)
                    .TextFieldTitleStyle(title: "Address", placeholder: "Address", text: $address)
                
                TextField("Contact", text: $contact)
                    .TextFieldTitleStyle(title: "Contact", placeholder: "Supplier Contact", text: $contact)
                
                Section(header: Text("Location")) {
                    
                    if latitude != 0.0 && longitude != 0.0 {
                        Button("Change Location") {
                            isShowingMapPicker = true
                        }

                        Text("Coordinates: \(latitude), \(longitude)")
                        
                        Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )), annotationItems: [
                            AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
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
                    saveSupplier()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(
                                cornerRadius: 50,
                                style: .continuous
                            )
                            .fill(.orangeFF7F13)
                        )
                }

            }
            .padding(20)
            .hideTabBar()
            .sheet(isPresented: $isShowingMapPicker) {
                MapPickerView(latitude: $latitude, longitude: $longitude, isPresented: $isShowingMapPicker)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Save Supplier"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // MARK: - Save Supplier
    private func saveSupplier() {
        guard !name.isEmpty, !address.isEmpty, !contact.isEmpty, latitude != 0.0, longitude != 0.0 else {
            alertMessage = "Please fill in all fields and select a location."
            showAlert = true
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else {
            alertMessage = "UserID not found"
            showAlert = true
            return
        }
        
        let newSupplier = Supplier(
            id: UUID().uuidString,
            userID: userID,
            name: name,
            address: address,
            contact: contact,
            longitude: longitude,
            latitude: latitude
        )
        
        Task {
            do {
                await supplierViewModel.addSupplier(supplier: newSupplier)
                alertMessage = "Supplier successfully saved!"
                showAlert = true
                resetFields()
            }
        }
    }
    
    // MARK: - Reset Fields
    private func resetFields() {
        name = ""
        address = ""
        contact = ""
        latitude = 0.0
        longitude = 0.0
    }
}

#Preview {
    AddSupplierView()
}

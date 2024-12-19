//
//  AddSupplierView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import Foundation
import SwiftUI

struct AddSupplierView: View {
    @State private var name = ""
    @State private var address = ""
    @State private var contact = ""
    @State private var latitude = 0.0
    @State private var longitude = 0.0

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                
                TextField("Name", text: $name)
                    .TextFieldTitleStyle(title: "Nama", placeholder: "Name", text: $name)
                
                TextField("Address", text: $address)
                    .TextFieldTitleStyle(title: "Address", placeholder: "Address", text: $address)

                TextField("Contact", text: $contact)
                    .TextFieldTitleStyle(title: "Contact", placeholder: "Supplier Contact", text: $contact)
                
                
                Section(header: Text("Location")) {
                    Button("Get Current Location") {
                        latitude = 37.7749 // Example coordinate
                        longitude = -122.4194
                    }
                    
                    if latitude != 0.0 && longitude != 0.0 {
                        Text("Coordinates: \(latitude), \(longitude)")
                    }
                }
                
                Spacer()
                
                Button {
                    let newSupplier = Supplier(id: UUID().uuidString, name: name, address: address, contact: contact, latitude: latitude, longitude: longitude)
                    
                    print("save supplier : \(newSupplier)")
                    
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
            .navigationTitle("Add Supplier")
            
        }
    }
}

#Preview {
    AddSupplierView()
}

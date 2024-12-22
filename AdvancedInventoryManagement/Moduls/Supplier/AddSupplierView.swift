//
//  AddSupplierView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import Foundation
import SwiftUI
import MapKit

struct AddSupplierView: View {
    @State private var name = ""
    @State private var address = ""
    @State private var contact = ""
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    @State private var isShowingMapPicker = false

    var body: some View {
        NavigationView {
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
                .hideTabBar()
                .sheet(isPresented: $isShowingMapPicker) {
                    MapPickerView(latitude: $latitude, longitude: $longitude, isPresented: $isShowingMapPicker)

                }
            }

        }
    }
}

#Preview {
    AddSupplierView()
}

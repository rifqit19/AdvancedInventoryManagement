//
//  MapPickerView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapPickerView: View {
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Binding var isPresented: Bool

    @State private var annotations: [AnnotationItem] = []
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var searchText: String = ""
    @StateObject private var locationManagerDelegate = CLLocationManagerDelegateWrapper() // untuk mengelola lokasi pengguna
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, onSearch: searchLocation)
            
            // Map with annotation and interaction support
            MapViewRepresentable(region: $region, annotations: $annotations, onTap: addAnnotation(at:))
                .edgesIgnoringSafeArea(.all)
            
            HStack (){
                
                Text("lat: \(latitude),long: \(longitude)")
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)


                Button {
                    locationManagerDelegate.requestLocation()
                } label: {
                    Image(systemName: "location")
                        .padding()
                        .frame(width: 40, height: 40)
                        .background(.orangeFF7F13)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                }

            }
            .padding()

            
            Button(action: {
                print("Selected Location: \(latitude), \(longitude)")
                isPresented = false
            }) {
                Text("Select Location")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.orangeFF7F13)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            setupLocationManager()
        }
    }

    // current location setting
    private func setupLocationManager() {
        locationManagerDelegate.onLocationUpdate = { location in
            if let location = location {
                let coordinate = location.coordinate
                latitude = coordinate.latitude
                longitude = coordinate.longitude
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                annotations = [AnnotationItem(coordinate: coordinate)]
            }
        }
        locationManagerDelegate.requestLocation()
    }

    // add anotation on tapped location
    private func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        annotations = [AnnotationItem(coordinate: coordinate)]
        
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    // search location
    private func searchLocation(query: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response, let firstItem = response.mapItems.first else {
                print("Location not found or error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let coordinate = firstItem.placemark.coordinate
            DispatchQueue.main.async {
                latitude = coordinate.latitude
                longitude = coordinate.longitude
                region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                annotations = [AnnotationItem(coordinate: coordinate)]
            }
        }
    }
}

//#Preview {
//    MapPickerView()
//}

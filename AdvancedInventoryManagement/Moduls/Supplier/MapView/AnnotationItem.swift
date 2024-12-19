//
//  AnnotationItem.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 19/12/24.
//


// Model untuk anotasi pada MapView
struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

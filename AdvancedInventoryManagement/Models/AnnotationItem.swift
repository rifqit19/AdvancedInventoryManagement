//
//  AnnotationItem.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 19/12/24.
//

import SwiftUI
import MapKit

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

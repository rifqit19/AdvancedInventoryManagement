//
//  Supplier.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import Foundation
import FirebaseFirestore

struct Supplier: Identifiable, Codable, Equatable {
    @DocumentID var id: String? // Firestore document ID
    var userID: String
    var name: String
    var address: String
    var contact: String
    var longitude: Double
    var latitude: Double
    
    init(id: String, userID: String, name: String, address: String, contact: String, longitude: Double, latitude: Double) {
        self.id = id
        self.userID = userID
        self.name = name
        self.address = address
        self.contact = contact
        self.longitude = longitude
        self.latitude = latitude
    }
    
}


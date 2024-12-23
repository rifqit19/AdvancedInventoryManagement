//
//  Supplier.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import Foundation
import FirebaseFirestore

struct Supplier: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID
    var userID: String
    var name: String
    var address: String
    var contact: String
    var longitude: Double
    var latitude: Double
    var items: [Item] = [] // Barang di dalam supplier
    
    // Custom initializer
    init(id: String, userID: String, name: String, address: String, contact: String, longitude: Double, latitude: Double) {
        self.id = id
        self.userID = userID
        self.name = name
        self.address = address
        self.contact = contact
        self.longitude = longitude
        self.latitude = latitude
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userID
        case name
        case address
        case contact
        case longitude
        case latitude
    }
    
    // Manual Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.contact = try container.decode(String.self, forKey: .contact)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.items = [] // Fetch manually if necessary
    }
    
    // Manual Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(userID, forKey: .userID)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(contact, forKey: .contact)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(latitude, forKey: .latitude)
    }
}

struct Supplier2: Identifiable {
    let id: String
    let name: String
    let address: String
    let contact: String
    let latitude: Double
    let longitude: Double
}

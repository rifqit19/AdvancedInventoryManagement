//
//  Item.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

struct SQLItem: Identifiable {
    var id: Int
    var name: String
    var description: String
    var category: String
    var price: Double
    var stock: Int
    var imagePath: String
}


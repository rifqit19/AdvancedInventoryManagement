//
//  Transaction.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI

struct Transaction: Identifiable {
    var id: Int
    var itemId: Int
    var itemName: String
    var type: String
    var quantity: Int
    var date: Date
}

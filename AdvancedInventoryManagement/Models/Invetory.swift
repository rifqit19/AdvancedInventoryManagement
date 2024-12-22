//
//  Invetory.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 15/12/24.
//

import Foundation

struct Inventory: Identifiable {
    let id: String
    let name: String
    let quantity: Int
    let supplierID: String
    let supplierName: String
}

//struct Item: Identifiable {
//    let id = UUID()
//    var nama: String
//    var deskripsi: String
//    var kategori: String
//    var harga: Double
//    var stok: Int
//    var image: UIImage
//    var transaction: [Transaction]
//}
//
//struct Transaction: Identifiable {
//    let id = UUID()
//    var jenis: String // Masuk/Keluar
//    var jumlah: Int
//    var tanggal: Date
//}

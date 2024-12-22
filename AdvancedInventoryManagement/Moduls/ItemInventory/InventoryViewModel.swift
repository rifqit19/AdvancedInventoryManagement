//
//  InventoryViewModel.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI
import Foundation

class InventoryViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var transactions: [Transaction] = []

    init() {
        loadItems()
        loadTransactions()
    }

    func loadItems() {
        let query = "SELECT * FROM Items"
        let results = SQLiteHelper.shared.fetchQuery(query)
        items = results.map {
            Item(
                id: $0["id"] as? Int ?? 0,
                name: $0["name"] as? String ?? "",
                description: $0["description"] as? String ?? "",
                category: $0["category"] as? String ?? "",
                price: $0["price"] as? Double ?? 0.0,
                stock: $0["stock"] as? Int ?? 0,
                imagePath: $0["imagePath"] as? String ?? ""
            )
        }
    }
    
    func loadTransactions() {
        let query = "SELECT * FROM Transactions"
        let results = SQLiteHelper.shared.fetchQuery(query)
        
        let dateFormatter = ISO8601DateFormatter()
        
        transactions = results.map { row in
            let id = row["id"] as? Int ?? 0
            let itemId = row["itemId"] as? Int ?? 0
            let itemName = row["itemName"] as? String ?? ""
            let type = row["type"] as? String ?? ""
            let quantity = row["quantity"] as? Int ?? 0
            
            let date: Date = {
                if let dateString = row["date"] as? String,
                   let parsedDate = dateFormatter.date(from: dateString) {
                    return parsedDate
                }
                return Date()
            }()
            
            return Transaction(
                id: id,
                itemId: itemId,
                itemName: itemName,
                type: type,
                quantity: quantity,
                date: date
            )
        }

    }

    func addItem(name: String, description: String, category: String, price: Double, stock: Int, imagePath: String) {
        let query = """
        INSERT INTO Items (name, description, category, price, stock, imagePath)
        VALUES ('\(name)', '\(description)', '\(category)', \(price), \(stock), '\(imagePath)');
        """
        SQLiteHelper.shared.executeQuery(query)
        loadItems()
    }

    func addTransaction(itemId: Int, itemName: String, type: String, quantity: Int, date: Date) {
        let dateString = ISO8601DateFormatter().string(from: date)
        let query = """
        INSERT INTO Transactions (itemId, itemName, type, quantity, date)
        VALUES (\(itemId),'\(itemName)', '\(type)', \(quantity), '\(dateString)');
        """
        SQLiteHelper.shared.executeQuery(query)

        if type == "Masuk" {
            updateStock(itemId: itemId, quantity: quantity)
        } else if type == "Keluar" {
            updateStock(itemId: itemId, quantity: -quantity)
        }
        
        loadTransactions()
        print("cek history transaksi = \(transactions)")
        for transaction in transactions {
            print("item transaction = \(transaction.itemId)")
        }
    }

    private func updateStock(itemId: Int, quantity: Int) {
        let query = """
        UPDATE Items SET stock = stock + \(quantity) WHERE id = \(itemId);
        """
        SQLiteHelper.shared.executeQuery(query)
        loadItems()
    }
}

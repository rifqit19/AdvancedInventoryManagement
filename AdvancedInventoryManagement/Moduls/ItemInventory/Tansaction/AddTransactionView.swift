//
//  AddTransactionView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Binding var isPresented: Bool

    @StateObject private var transactionViewModel = TransactionViewModel()
    
    var supplierID: String
    var itemID: String
    var itemName: String

    @State private var transactionType = "Masuk"
    @State private var quantity = ""
    @State private var date = Date()

    var body: some View {
        VStack {
            Text("Tambah Transaksi")
                .font(.headline)
                .bold()

            Form {
                Picker("Jenis Transaksi", selection: $transactionType) {
                    Text("Masuk").tag("Masuk")
                    Text("Keluar").tag("Keluar")
                }
                
                TextField("Jumlah", text: $quantity)
                    .keyboardType(.numberPad)
                    .onChange(of: quantity) { newValue in
                        quantity = newValue.filter { $0.isNumber }
                    }

                DatePicker("Tanggal", selection: $date, displayedComponents: .date)
            }

            Button(action: {
                let quantityValue = Int(quantity) ?? 0
                
                let transaction = Transaction(itemId: itemID, itemName: itemName, type: transactionType, quantity: transactionType == "Masuk" ? quantityValue : -quantityValue, date: date, supplierID: supplierID)
                print("cek transaksi: \(transaction)")

                Task {
                    await transactionViewModel.addTransaction(idSupplier: supplierID, idItem: itemID, transaction: transaction)
                    isPresented = false
                }
                
            }) {
                Text("Save Transaction")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.orangeFF7F13)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding()
        }
    }
}

#Preview {
//    let sampleViewModel = InventoryViewModel()
    AddTransactionView(isPresented: .constant(true), supplierID: "", itemID: "", itemName: "Beras")
}

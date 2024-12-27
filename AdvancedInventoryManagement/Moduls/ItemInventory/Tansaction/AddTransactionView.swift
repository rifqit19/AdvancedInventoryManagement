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
    var currentStock: Int

    @State private var transactionType = "Masuk"
    @State private var quantity = ""
    @State private var date = Date()
    
    @State private var showAlert = false
    @State private var alertMessage = ""

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
                
                if transactionType == "Keluar" && quantityValue > currentStock {
                    alertMessage = "Out of stock."
                    showAlert = true
                    return
                }

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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Warning!"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }

    }
}

#Preview {
//    let sampleViewModel = InventoryViewModel()
    AddTransactionView(isPresented: .constant(true), supplierID: "", itemID: "", itemName: "Beras", currentStock: 10)
}

//
//  AddTransactionView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Binding var isPresented: Bool

    @ObservedObject var viewModel: InventoryViewModel
    var itemId: Int
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
                        // Pastikan hanya angka yang dapat dimasukkan
                        quantity = newValue.filter { $0.isNumber }
                    }

                DatePicker("Tanggal", selection: $date, displayedComponents: .date)
            }

            Button(action: {
                let quantityValue = Int(quantity) ?? 0
                print("cek transaksi: \(transactionType) : \(quantity) : \(date)")
                viewModel.addTransaction(itemId: itemId, itemName: itemName,  type: transactionType, quantity: quantityValue, date: date)
                isPresented = false
            }) {
                Text("Simpan Transaksi")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding()
        }
    }
}

#Preview {
    let sampleViewModel = InventoryViewModel()
    AddTransactionView(isPresented: .constant(true), viewModel: sampleViewModel, itemId: 1, itemName: "Beras")
}

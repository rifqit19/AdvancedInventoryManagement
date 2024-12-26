//
//  ItemDetailView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI

struct ItemDetailView: View {
    
    var item: Item
    @State private var showingAddTransactionView = false

    @StateObject private var transactionViewModel = TransactionViewModel()

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                                .cornerRadius(10)
                                .padding(.top, 16)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }
                    }


                    VStack(alignment: .leading, spacing: 4){

                        Text(item.name)
                            .font(.title)
                            .bold()

                        HStack {
                            Text("\(item.category)")
                            Spacer()
                            Text("Rp \(item.price, specifier: "%.2f")")
                        }
                        
                    }

                    Text(item.description)
                        .font(.body)
                        .foregroundColor(.gray)

                    Text("Stok: \(item.stock)")

                    Divider()

                    Text("Riwayat Transaksi: ")
                        .font(.headline)

                    if transactionViewModel.transactions.isEmpty {
                        Text("No transaction available.")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        ForEach(transactionViewModel.transactions) { transaction in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack (alignment: .center) {
                                    Text(transaction.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()

                                    VStack{
                                        Text(transaction.type)
                                            .font(.headline)
                                            .foregroundColor(transaction.type == "Masuk" ? .green : .red)
                                        
                                        Text(transaction.type == "Masuk" ? "+\(transaction.quantity)" : "\(transaction.quantity)")
                                            .font(.title2)
                                            .foregroundColor(transaction.type == "Masuk" ? .green : .red)

                                    }
                                }
                                
                            }
                            .padding(.vertical, 8)
                            
                            Divider()
                        }
                        .listStyle(PlainListStyle())

                    }

                    Spacer()
                }
                .padding()
            }

            Button(action: {
                showingAddTransactionView = true
            }) {
                Text("Add Transaction")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.orangeFF7F13)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding()
            .sheet(isPresented: $showingAddTransactionView, onDismiss: {
                Task{
                    await transactionViewModel.fetchTransactions(idSupplier: item.supplierID, idItem: item.id ?? "")
                }
            }) {
                AddTransactionView(isPresented: $showingAddTransactionView, supplierID: item.supplierID, itemID: item.id ?? "", itemName: item.name)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("Detail Item")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            Task{
                await transactionViewModel.fetchTransactions(idSupplier: item.supplierID, idItem: item.id ?? "")
            }
        }
        .hideTabBar()
        
    }
}

#Preview {
    let sampleItem = Item(
        name: "name",
        description: "desc",
        category: "cat",
        price: 10.000,
        stock: 10,
        supplierID: "1",
        supplierName: "supplier",
        userID: "1")
    

    ItemDetailView( item: sampleItem)
}


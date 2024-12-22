//
//  ItemDetailView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var viewModel: InventoryViewModel
    var item: Item
    @State private var showingAddTransactionView = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    Image(uiImage: UIImage(contentsOfFile: item.imagePath) ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                        .cornerRadius(10)
                        .padding(.top, 16)

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

                    
                    Divider()

                    HStack {
                        Text("Riwayat Transaksi: \(viewModel.transactions.filter { $0.itemId == item.id }.count)")
                            .font(.headline)
                        
                        Spacer()
                        Divider()
                        Spacer()
                        
                        Text("Stok: \(item.stock)")
                    }

                    ForEach(viewModel.transactions.filter { $0.itemId == item.id }) { transaction in
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
                                    
                                    Text(transaction.type == "Masuk" ? "+\(transaction.quantity)" : "-\(transaction.quantity)")
                                        .font(.title2)
                                        .foregroundColor(transaction.type == "Masuk" ? .green : .red)

                                }
                            }
                            
                        }
                        .padding(.vertical, 8)
                        
                        Divider()
                    }
                    .listStyle(PlainListStyle())
                    .onAppear {
                        print("Filtered transactions: \(viewModel.transactions.filter { $0.itemId == item.id })")
                    }

                    Spacer()
                }
                .padding()
            }

            Button(action: {
                showingAddTransactionView = true
            }) {
                Text("Tambah Transaksi")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding()
            .sheet(isPresented: $showingAddTransactionView) {
                AddTransactionView(isPresented: $showingAddTransactionView, viewModel: viewModel, itemId: item.id, itemName: item.name)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .hideTabBar()
        
    }
}

#Preview {
    let sampleItem = Item(
        id: 1,
        name: "test", description: "test description",
        category: "categoty1",
        price: 10000,
        stock: 5,
        imagePath: ""
    )
    let sampleViewModel = InventoryViewModel()

    ItemDetailView(viewModel: sampleViewModel, item: sampleItem)
}


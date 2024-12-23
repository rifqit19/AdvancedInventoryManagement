//
//  ItemListView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI

struct ItemListView: View {
    @StateObject var viewModel = InventoryViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.items.isEmpty {
                    VStack {
                        
                        Spacer()
                        
                        Image(systemName: "folder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("Tidak ada barang")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("Tambahkan barang dengan menekan tombol +")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                } else {
                    VStack {

                        List(viewModel.items) { item in
                            HStack {
                                Image(uiImage: loadImageFromPath(item.imagePath))
                                    .resizable()
                                    .frame(width: 70, height: 60)
                                    .cornerRadius(8)
                                    .scaledToFill()
                                
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.category)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                    Text("Rp \(item.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                    Text("Stok: \(item.stock)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                }
                                Spacer()
                                NavigationLink(destination: ItemDetailView(viewModel: viewModel, item: item)) {
                                }
                                
                            }
                            .padding(.vertical, 8)
                        }
                        .listStyle(PlainListStyle())

                    } // end of vstack
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddItemView(viewModel: viewModel)) {
                            
                            ZStack {
                                Circle()
                                    .fill(.orangeFF7F13)
                                    .frame(width: 60, height: 60)
                                    .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                    }
                } // end of vstack
            }
            .navigationTitle("Inventory Items")

            .showTabBar()
        }
    }

    func loadImageFromPath(_ path: String) -> UIImage {
        if let image = UIImage(contentsOfFile: path) {
            return image
        }
        return UIImage(systemName: "photo")!
    }
}

#Preview {
    ItemListView()
}

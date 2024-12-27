//
//  ItemListView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI

struct ItemListView: View {
    @ObservedObject var itemViewModel = ItemViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                if !itemViewModel.items.filter({ $0.userID == authViewModel.currentUser?.id }).isEmpty {
                    List(itemViewModel.items.filter { $0.userID == authViewModel.currentUser?.id }) { item in
                        NavigationLink(destination: ItemDetailView(item: item)){
                                   HStack(alignment: .top, spacing: 16) {
                                       if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                                           AsyncImage(url: url) { image in
                                               image
                                                   .resizable()
                                                   .aspectRatio(contentMode: .fill)
                                                   .frame(width: 60, height: 60)
                                                   .cornerRadius(8)
                                                   .shadow(radius: 2)
                                           } placeholder: {
                                               ProgressView()
                                                   .frame(width: 60, height: 60)
                                           }
                                       } else {
                                           Rectangle()
                                               .fill(Color.gray.opacity(0.3))
                                               .frame(width: 60, height: 60)
                                               .cornerRadius(8)
                                               .overlay(Text("No Image").font(.caption).foregroundColor(.gray))
                                       }
                                       
                                       // Informasi Item
                                       VStack(alignment: .leading, spacing: 8) {
                                           Text(item.name)
                                               .font(.headline)
                                               .lineLimit(1)
                                           
                                           Text("Price: Rp.\(item.price, specifier: "%.2f")")
                                               .font(.subheadline)
                                               .foregroundColor(.secondary)
                                           
                                           Text("Stock: \(item.stock)")
                                               .font(.subheadline)
                                               .foregroundColor(item.stock > 0 ? .green : .red)
                                           
                                           Text("Category: \(item.category)")
                                               .font(.subheadline)
                                               .foregroundColor(.secondary)
                                           
                                               Text("Supplier: \(item.supplierName)")
                                                   .font(.subheadline)
                                                   .foregroundColor(.secondary)
                                       }
                                   }
                                   .padding(.vertical, 8)
                               }
                           }
                    .listStyle(PlainListStyle())

                } else {
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

                }
                
                // Floating Action Button
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        NavigationLink(destination: AddItemView(supplierID: "1", supplierName: "")) {
//                            
//                            ZStack {
//                                Circle()
//                                    .fill(.orangeFF7F13)
//                                    .frame(width: 60, height: 60)
//                                    .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 5)
//                                
//                                Image(systemName: "plus")
//                                    .font(.system(size: 24, weight: .bold))
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        .padding()
//                    }
//                } // end of vstack

            }
            .onAppear(perform: {
                itemViewModel.fetchItems()
            })
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

//
//  DashboardView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 27/12/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dashboardViewModel: DashboardViewModel

    @State private var showItemList = false
    @State private var showSupplierList = false

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {

                Button(action: {
                    showItemList = true
                }) {
                    VStack(alignment: .center) {
                        Image(systemName: "list.dash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)

                        Text("Total Barang")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("\(dashboardViewModel.totalItems)")
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .sheet(isPresented: $showItemList) {
                    ItemListView()
                }


                Button(action: {
                    showSupplierList = true
                }) {
                    VStack(alignment: .center) {
                        Image(systemName: "doc.text")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)

                        Text("Total Supplier")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("\(dashboardViewModel.totalSuppliers)")
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                .sheet(isPresented: $showSupplierList) {
                    SupplierView()
                }

                Spacer()
            }
            .navigationTitle("Dashboard")
            .padding()
            .onAppear(perform: {
                Task {
                    await dashboardViewModel.fetchTotalItems()
                    await dashboardViewModel.fetchTotalSuppliers()
                }
            })
        }
    }
}

#Preview {
    DashboardView()
}

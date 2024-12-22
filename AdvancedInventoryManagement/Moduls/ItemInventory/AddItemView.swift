//
//  AddItemView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI

struct AddItemView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: InventoryViewModel
    @State private var name = ""
    @State private var description = ""
    @State private var category = ""
    @State private var price: String = ""
    @State private var stock: String = ""
    @State private var imagePath = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var showImagePickerOption = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var categoryItems = ["Makanan", "Minuman"]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 16){
                        
                        TextField("Nama Barang", text: $name)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Deskripsi", text: $description)
                            .textFieldStyle(.roundedBorder)
                        
                        
                        HStack {
                            TextField("Kategory", text: $category)
                                .textFieldStyle(.roundedBorder)
                            
                            Menu {
                                ForEach(categoryItems, id: \.self){ item in
                                    Button(item) {
                                        self.category = item
                                    }
                                }
                            } label: {
                                VStack(spacing: 5){
                                    Image(systemName: "chevron.down")
                                        .font(.title3)
                                    
                                }
                            }
                            
                        }
                        
                        TextField("Harga", text: $price)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        
                        TextField("Stok", text: $stock)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        
                        
                        Section(header: Text("Foto Barang")) {
                            
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(10)
                            }
                            
                            Button {
                                showImagePickerOption.toggle()
                            } label: {
                                Text(selectedImage == nil ? "Pilih Foto" : "Ganti Foto")
                            }
                            
                        }
                        .padding(.top, 20)
                        
                        
                    }
                    .padding()
                    .navigationBarTitleDisplayMode(.inline)
                    .actionSheet(isPresented: $showImagePickerOption) {
                        ActionSheet(title: Text("Pilih Sumber Gambar"), buttons: [
                            .default(Text("Kamera")) {
                                imageSourceType = .camera
                                isImagePickerPresented = true
                            },
                            .default(Text("Galeri")) {
                                imageSourceType = .photoLibrary
                                isImagePickerPresented = true
                            },
                            .cancel()
                        ])
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePickerView(selectedImage: $selectedImage, isPresented: $isImagePickerPresented, sourceType: imageSourceType)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    saveItem()
                }) {
                    Text("Tambah Barang")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.orangeFF7F13)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding()
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .hideTabBar()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Kesalahan"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationTitle("Tambah Barang")
    }
    
    func saveItem() {
        if name.isEmpty || description.isEmpty || category.isEmpty || price.isEmpty || stock.isEmpty {
            alertMessage = "Harap isi semua field sebelum menambah barang."
            showAlert = true

        } else {
            if let price = Double(price), let stock = Int(stock) {
                let filePath = saveImageToDocuments(image: selectedImage)
                viewModel.addItem(name: name, description: description, category: category, price: price, stock: stock, imagePath: filePath)
                dismiss()
            } else {
                alertMessage = "Harga harus berupa angka desimal dan stok harus berupa angka bulat."
                showAlert = true
            }
        }

    }
    
    func saveImageToDocuments(image: UIImage?) -> String {
        guard let image = image else { return "" }

        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = directory.appendingPathComponent(UUID().uuidString + ".jpg")

        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: filePath)
                return filePath.path
            } catch {
                print("Error saving image: \(error)")
            }
        }
        return ""
    }
}

#Preview {
    let sampleViewModel = InventoryViewModel()

    AddItemView(viewModel: sampleViewModel)
}

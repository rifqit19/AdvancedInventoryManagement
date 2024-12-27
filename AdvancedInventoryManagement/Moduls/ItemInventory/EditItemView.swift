//
//  EditItemView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 27/12/24.
//

import SwiftUI
import FirebaseAuth

struct EditItemView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ItemViewModel()
    
    var item: Item
    
    @State private var name: String
    @State private var description: String
    @State private var category: String
    @State private var price: String
    @State private var stock: String
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isImagePickerPresented = false
    @State private var showImagePickerOption = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showAlert = false
    @State private var alertMessage = ""

    var categoryItems = ["Food", "Drink"]
    
    init(item: Item) {
        self.item = item
        _name = State(initialValue: item.name)
        _description = State(initialValue: item.description)
        _category = State(initialValue: item.category)
        _price = State(initialValue: String(item.price))
        _stock = State(initialValue: String(item.stock))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Edit Item")
                        .font(.title2)
                        .bold()
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Description", text: $description)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        TextField("Category", text: $category)
                            .textFieldStyle(.roundedBorder)
                        
                        Menu {
                            ForEach(categoryItems, id: \.self) { item in
                                Button(item) {
                                    self.category = item
                                }
                            }
                        } label: {
                            VStack(spacing: 5) {
                                Image(systemName: "chevron.down")
                                    .font(.title3)
                            }
                        }
                    }
                    
                    TextField("Price", text: $price)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    
                    TextField("Stock", text: $stock)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                    
                    Section(header: Text("Photo")) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                        } else if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                    .cornerRadius(10)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        Button {
                            showImagePickerOption.toggle()
                        } label: {
                            Text(selectedImage == nil ? "Select Image" : "Change Image")
                        }
                    }
                    .padding(.top, 20)
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .actionSheet(isPresented: $showImagePickerOption) {
                    ActionSheet(title: Text("Select Image Source"), buttons: [
                        .default(Text("Camera")) {
                            imageSourceType = .camera
                            isImagePickerPresented = true
                        },
                        .default(Text("Gallery")) {
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
                updateItem()
            }) {
                Text("Save Changes")
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
                title: Text("Failed"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func updateItem() {
        Task {
            do {
                guard !name.isEmpty, !description.isEmpty, !category.isEmpty, !price.isEmpty, !stock.isEmpty else {
                    alertMessage = "Please fill in all fields."
                    showAlert = true
                    return
                }

                guard let price = Double(price),
                      let stock = Int(stock) else {
                    alertMessage = "Please fill in all fields correctly."
                    showAlert = true
                    return
                }

                var updatedItem = item
                updatedItem.name = name
                updatedItem.description = description
                updatedItem.category = category
                updatedItem.price = price
                updatedItem.stock = stock
                
                if let newImage = selectedImage,
                   let imageData = newImage.jpegData(compressionQuality: 0.5) {
                    await viewModel.editItem(for: item.supplierID, item: updatedItem, newImageData: imageData)
                } else {
                    await viewModel.editItem(for: item.supplierID, item: updatedItem, newImageData: nil)
                }
                dismiss()
            }
        }
    }
}

#Preview {
    EditItemView(item: Item(name: "Sample", description: "Sample Description", category: "Food", price: 10.0, stock: 5, supplierID: "1", supplierName: "Store 1", userID: "123"))
}

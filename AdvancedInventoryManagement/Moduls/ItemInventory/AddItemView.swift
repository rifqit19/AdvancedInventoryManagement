//
//  AddItemView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 18/12/24.
//

import SwiftUI
import FirebaseAuth

struct AddItemView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel = ItemViewModel()

    var supplierID: String
    var supplierName: String

    @State private var name = ""
    @State private var description = ""
    @State private var category = ""
    @State private var price: String = ""
    @State private var stock: String = ""
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var showImagePickerOption = false
    @State private var imageSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var categoryItems = ["Food", "Drink"]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16){
                    Text("Add Item")
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
                saveItem()
            }) {
                Text("Add Item")
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
    
    func saveItem() {
        Task {
            do {
                guard let price = Double(price), let stock = Int(stock), let image = selectedImage,
                      let imageData = image.jpegData(compressionQuality: 0.5) else {
                    alertMessage = "Please fill in all fields correctly."
                    showAlert = true
                    return
                }
                
                guard let userID = Auth.auth().currentUser?.uid else {
                    alertMessage = "UserID not found"
                    showAlert = true
                    return
                }

                let newItem = Item(name: name, description: description, category: category, price: price, stock: stock, supplierID: supplierID, supplierName: supplierName, userID: userID)
                await viewModel.addItem(to: supplierID, item: newItem, imageData: imageData)
                dismiss()
            }
        }

    }
    
}

#Preview {

    AddItemView(supplierID: "1", supplierName: "store 1")
}

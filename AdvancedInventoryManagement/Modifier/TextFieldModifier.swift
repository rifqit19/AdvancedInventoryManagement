//
//  TextFieldModifier.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 12/12/24.
//

import SwiftUI

struct TextFieldWithTitle: ViewModifier {
    var title: String
    var placeholder: String
    @Binding var text: String

    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption2)
            
            TextField(placeholder, text: $text)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1))
        }
    }
    
}

struct SecureFieldModifier: ViewModifier {
    var title: String
    @Binding var text: String
    @State private var isSecure: Bool = true

    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption2)

            HStack {
                if isSecure {
                    SecureField("Enter your password", text: $text)
                        .textContentType(.password)

                } else {
                    TextField("Enter your password", text: $text)
                        .textContentType(.password)

                }
                
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )

        }
    }
}



extension View {
    func TextFieldTitleStyle(title: String, placeholder: String, text: Binding<String>) -> some View {
        self.modifier(TextFieldWithTitle(title: title, placeholder: placeholder, text: text))
    }
    
    func secureFieldStyle(title: String, text: Binding<String>) -> some View {
        self.modifier(SecureFieldModifier(title: title, text: text))
    }

    
}


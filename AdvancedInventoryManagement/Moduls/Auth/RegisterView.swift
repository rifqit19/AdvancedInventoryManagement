//
//  RegisterView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 12/12/24.
//


import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmationPassword: String = ""
    
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        GeometryReader { geo in
            ScrollView{
                VStack(alignment: .center) {
                    
                    Text("Register")
                        .font(.title)
                        .bold()
                    
                    Text("Create your profile to start your journey")
                        .font(.caption)
                        .padding(.top, 2)

                    Group {
                        TextField("type your name", text: $name)
                            .TextFieldTitleStyle(title: "Nama", placeholder: "type your name", text: $name)
                        
                        TextField("type your email", text: $email)
                            .TextFieldTitleStyle(title: "Email", placeholder: "type your email", text: $email)

                        TextField("type your phone number", text: $phone)
                            .TextFieldTitleStyle(title: "No. Handphone", placeholder: "type your phone number", text: $phone)

                        SecureField("type your password", text: $password)
                            .secureFieldStyle(title: "Password", text: $password)
                        

                        SecureField("retype your password", text: $confirmationPassword)
                            .secureFieldStyle(title: "Confirmation Password", text: $confirmationPassword)

                    }
                    .padding(.top, 20)
                    
                    
                    HStack{
                        Text("Already have an account? ")
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Login")
                                .foregroundStyle(.black)
                                .bold()
                        }
                    }
                    .padding([.top, .bottom], 20)

                            
                    Button {
                        Task {
                            try await viewModel.createUser(withEmail: email, password: password, fullname: name)
                        }
                    } label: {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 50,
                                    style: .continuous
                                )
                                .fill(.orangeFF7F13)
                            )
                        
                    }
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)

                    Spacer()
                } // VStack
                .padding(20)
                .frame(minHeight: geo.size.height)
                
            } // ScrollView
        } // geometry reader
    }
}

// MARK: AutenticationFormProtocol

extension RegisterView : AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 5
        && confirmationPassword == password
        && !name.isEmpty
    }
}



#Preview {
    RegisterView()
}


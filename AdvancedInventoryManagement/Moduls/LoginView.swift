//
//  LoginView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 12/12/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var showRegister = false
    @State private var showMain = false

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(alignment: .center) {
            
            Text("Login")
                .font(.title)
                .bold()
            
            Image("img_login")
                .resizable()
                .scaledToFit()

            
            Text("Create your profile to start your journey")
                .font(.caption)
                .padding(.top, 2)
            

            Group {
                
                TextField("type your email", text: $email)
                    .TextFieldTitleStyle(title: "Email", placeholder: "type your email", text: $email)


                SecureField("type your password", text: $password)
                    .secureFieldStyle(title: "Password", text: $password)
                
            }
            .padding(.top, 20)
                    
            HStack{
                Text("Not have an account? ")
                
                Button {
                    showRegister = true
                } label: {
                    Text("Register")
                        .foregroundStyle(.black)
                        .bold()
                }
                .fullScreenCover(isPresented: $showRegister) {
                    RegisterView()
                }
            }.padding([.top, .bottom], 20)

            
            Button {
                showMain = true
            } label: {
                Text("Login")
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
            .fullScreenCover(isPresented: $showMain) {
                ContentView()
            }
            

            Spacer()
        } // VStack
        .padding(20)
    }
}

#Preview {
    LoginView()
}

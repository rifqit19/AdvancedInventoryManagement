//
//  AccountView.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 22/12/24.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        if let user = viewModel.currentUser {
            NavigationView {
                VStack (spacing: 16) {
                    Text(user.initials)
                        .font(.headline)

                    Text(user.fullname)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button {
                        
                        viewModel.signOut()
                        
                    } label: {
                        Text("Logout")
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

                }
                .padding()
                .navigationTitle("Account")
                .showTabBar()
            }

        }
    }
}

#Preview {
    AccountView()
}

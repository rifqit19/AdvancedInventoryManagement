//
//  AuthViewModel.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 22/12/24.
//


import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password) // Authentication user
            self.userSession = result.user // update userSession with authentication result
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
        }
        
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) // create new user at Firebase Authentication
            self.userSession = result.user // save to session
            let user = User(id: result.user.uid, fullname: fullname, email: email) // create object model for save user data at forestore
            
            let encodeUser = try Firestore.Encoder().encode(user) // encrypt Firestore.Encoder()
            try await Firestore.firestore().collection("users").document(user.id).setData(encodeUser) // save user data to users collection
            
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } // get uid current user at userSession
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else  { return } 
        self.currentUser = try? snapshot.data(as: User.self) // parsing data to user object and save to current user
        
    }
    
    // MARK: not used function
    
    func deleteUser() {
        
    }

}

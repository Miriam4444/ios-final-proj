//
//  LoginVM.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//
import Foundation
import FirebaseAuth

@Observable
class LoginVM {
    var email: String = ""
    var password: String = ""
    var isAuthenticated: Bool = false
    var errorMessage: String?
    var currentUserId: String?
    
    init() {
        //this is to check if a user is alread logged in
        if let user = Auth.auth().currentUser {
            self.isAuthenticated = true
            self.currentUserId = user.uid
            self.email = user.email ?? ""
        }
    }
    
    //to sign up new user
    func signUp() {
        errorMessage = nil
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }
        
        Task {
            do {
                let result = try await Auth.auth().createUser(
                    withEmail: email,
                    password: password
                )
                
                await MainActor.run {
                    self.currentUserId = result.user.uid
                    self.isAuthenticated = true
                    self.errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    //log in user
    func login() {
        errorMessage = nil
        
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            errorMessage = "Please enter email and password."
            return
        }
        
        Task {
            do {
                let result = try await Auth.auth().signIn(
                    withEmail: email,
                    password: password
                )
                
                await MainActor.run {
                    self.currentUserId = result.user.uid
                    self.isAuthenticated = true
                    self.errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUserId = nil
            email = ""
            password = ""
            errorMessage = nil
        } catch {
            errorMessage = "Error signing out: \(error.localizedDescription)"
        }
    }
}

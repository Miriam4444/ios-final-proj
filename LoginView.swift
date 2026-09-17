//
//  LoginView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//
import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginVM
    @State private var isSignUpMode = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("MODELcule")
                    .font(.largeTitle)
                    .bold()
                
                Text(isSignUpMode ? "Create Account" : "Welcome Back")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    if isSignUpMode {
                        viewModel.signUp()
                    } else {
                        viewModel.login()
                    }
                }) {
                    Text(isSignUpMode ? "Sign Up" : "Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    isSignUpMode.toggle()
                    viewModel.errorMessage = nil
                }) {
                    Text(isSignUpMode ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.accentColor)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(isSignUpMode ? "Sign Up" : "Login")
        }
    }
}

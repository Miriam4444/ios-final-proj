//
//  SettingsView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/15/25.
//

import SwiftUI

struct SettingsView: View {
    var loginVM: LoginVM
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Account") {
                    if !loginVM.email.isEmpty {
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(loginVM.email)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack {
                            Text("Log Out")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("SE337: iOS App Development")
                        Spacer()
                        Text("Final Project")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Log Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    loginVM.logout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}

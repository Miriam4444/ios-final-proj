//
//  ContentView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//

import SwiftUI

struct ContentView: View {
    @State var loginVM = LoginVM()
        
    var body: some View {
        Group {
            if loginVM.isAuthenticated {
                MainTabView(loginVM: loginVM)
            } else {
                LoginView(viewModel: loginVM)
            }
        }
    }
}

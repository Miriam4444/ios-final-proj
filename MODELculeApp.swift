//
//  MODELculeApp.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//

import SwiftUI
import FirebaseCore

@main
struct MoleculeBuilderApp: App {
    
    init() {
        // Configure Firebase when app starts
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
           ContentView()
        }
    }
}

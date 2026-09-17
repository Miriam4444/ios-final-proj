//
//  MainTabView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct MainTabView: View {
    @State private var savedMoleculesVM = SavedMoleculesVM()
    @State private var notesVM = NotesVM()
    var loginVM: LoginVM
    
    var body: some View {
        TabView {
            MoleculeBuilderView(savedMoleculesVM: savedMoleculesVM)
                .tabItem {
                    Label("Build", systemImage: "atom")
                }
            
            SavedMoleculesView(viewModel: savedMoleculesVM, notesVM: notesVM)
                .tabItem {
                    Label("Molecules", systemImage: "square.stack.3d.up")
                }
            
            NotesView(viewModel: notesVM)
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
            
            PeriodicTableListView()
                .tabItem {
                    Label("Elements", systemImage: "list.bullet")
                }
            
            SettingsView(loginVM: loginVM)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

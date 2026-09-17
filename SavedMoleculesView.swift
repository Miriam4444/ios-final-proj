//
//  SavedMoleculesView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct SavedMoleculesView: View {
    @State var viewModel: SavedMoleculesVM
    @State var notesVM: NotesVM
    @State private var showingDeleteAlert = false
    @State private var moleculeToDelete: Molecule?
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.savedMolecules.isEmpty {
                    emptyState
                } else {
                    moleculesList
                }
            }
            .navigationTitle("Saved Molecules")
            .alert("Delete Molecule", isPresented: $showingDeleteAlert, presenting: moleculeToDelete) { molecule in
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteMolecule(molecule)
                }
            } message: { molecule in
                Text("Are you sure you want to delete '\(molecule.name)'?")
            }
        }
    }
    
    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.stack.3d.up")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Saved Molecules")
                .font(.title2)
                .bold()
            
            Text("Build and save molecules to see them here")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    var moleculesList: some View {
        List {
            ForEach(viewModel.savedMolecules) { molecule in
                NavigationLink(destination: MoleculeDetailView(molecule: molecule, notesVM: notesVM)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(molecule.name)
                            .font(.headline)
                        
                        HStack {
                            Text("\(molecule.placedAtoms.count) atoms")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Text("\(molecule.bonds.count) bonds")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(molecule.dateCreated, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        moleculeToDelete = molecule
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}

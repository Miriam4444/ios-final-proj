//
//  MoleculeDetailView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct MoleculeDetailView: View {
    let molecule: Molecule
    @State var notesVM: NotesVM
    @State private var showAddNote = false
    
    var moleculeNotes: [Note] {
        notesVM.notesForMolecule(molecule.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                moleculeInfo
                Divider()
                moleculeVisualization
                Divider()
                notesSection
            }
            .padding()
        }
        .navigationTitle(molecule.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddNote) {
            AddNoteView(
                moleculeId: molecule.id,
                notesVM: notesVM,
                onDismiss: {
                    showAddNote = false
                }
            )
        }
    }
    
    var moleculeInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Molecule Information")
                .font(.headline)
            
            HStack {
                Label("\(molecule.placedAtoms.count)", systemImage: "atom")
                    .font(.caption)
                
                Text("atoms")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label("\(molecule.bonds.count)", systemImage: "link")
                    .font(.caption)
                
                Text("bonds")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("Created: \(molecule.dateCreated, style: .date)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    var moleculeVisualization: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Structure")
                .font(.headline)
            
            Text("Atoms: \(molecule.placedAtoms.map { $0.atom.symbol }.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Notes")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { showAddNote = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
            
            if moleculeNotes.isEmpty {
                Text("No notes yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                ForEach(moleculeNotes) { note in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title)
                            .font(.subheadline)
                            .bold()
                        
                        Text(note.content)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(note.dateCreated, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
}

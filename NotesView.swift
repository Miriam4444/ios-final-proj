//
//  NotesView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct NotesView: View {
    @State var viewModel: NotesVM
    @State private var showAddNote = false
    @State private var showingDeleteAlert = false
    @State private var noteToDelete: Note?
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.notes.isEmpty {
                    emptyState
                } else {
                    notesList
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddNote = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteView(
                    moleculeId: nil,
                    notesVM: viewModel,
                    onDismiss: {
                        showAddNote = false
                    }
                )
            }
            .alert("Delete Note", isPresented: $showingDeleteAlert, presenting: noteToDelete) { note in
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteNote(note)
                }
            } message: { note in
                Text("Are you sure you want to delete '\(note.title)'?")
            }
        }
    }
    
    var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Notes")
                .font(.title2)
                .bold()
            
            Text("Add notes to remember anything important")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    var notesList: some View {
        List {
            ForEach(viewModel.notes) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title)
                            .font(.headline)
                        
                        Text(note.content)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        Text(note.dateCreated, style: .date)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        noteToDelete = note
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}

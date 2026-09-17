//
//  NotesVM.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/1/25.
//
import Foundation
import FirebaseAuth
import FirebaseDatabase

@Observable
class NotesVM {
    var notes: [Note] = []
    private let ref = Database.database().reference()
    
    init() {
        loadNotes()
    }
    
    //this is to load notes for user from firebase
    func loadNotes() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(userId).child("notes").observe(.value) { snapshot in
            var loadedNotes: [Note] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let dict = snapshot.value as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                   let note = try? JSONDecoder().decode(Note.self, from: jsonData) {
                    loadedNotes.append(note)
                }
            }
            
            self.notes = loadedNotes.sorted { $0.dateCreated > $1.dateCreated }
        }
    }
    
    func notesForMolecule(_ moleculeId: UUID) -> [Note] {
        return notes.filter { $0.moleculeId == moleculeId }
    }
    
    //this is to save a note to firebase for current user
    func saveNote(_ note: Note) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let noteRef = ref.child("users").child(userId).child("notes").child(note.id.uuidString)
        
        do {
            let data = try JSONEncoder().encode(note)
            if let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                noteRef.setValue(dict)
            }
        } catch {
            print("Error saving note: \(error)")
        }
    }
    
    //this is to delete a note from firebase
    func deleteNote(_ note: Note) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(userId).child("notes").child(note.id.uuidString).removeValue()
    }
}

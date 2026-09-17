//
//  SavedMoleculesVM.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import Foundation
import FirebaseAuth
import FirebaseDatabase

@Observable
class SavedMoleculesVM {
    var savedMolecules: [Molecule] = []
    private let ref = Database.database().reference()
    
    init() {
        loadMolecules()
    }
    
    // Load molecules for the current user from Firebase
    func loadMolecules() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(userId).child("molecules").observe(.value) { snapshot in
            var loadedMolecules: [Molecule] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let dict = snapshot.value as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                   let molecule = try? JSONDecoder().decode(Molecule.self, from: jsonData) {
                    loadedMolecules.append(molecule)
                }
            }
            
            self.savedMolecules = loadedMolecules.sorted { $0.dateCreated > $1.dateCreated }
        }
    }
    
    // Save a molecule to Firebase for the current user
    func saveMolecule(_ molecule: Molecule) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let moleculeRef = ref.child("users").child(userId).child("molecules").child(molecule.id.uuidString)
        
        do {
            let data = try JSONEncoder().encode(molecule)
            if let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                moleculeRef.setValue(dict)
            }
        } catch {
            print("Error saving molecule: \(error)")
        }
    }
    
    // Delete a molecule from Firebase
    func deleteMolecule(_ molecule: Molecule) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        ref.child("users").child(userId).child("molecules").child(molecule.id.uuidString).removeValue()
    }
}

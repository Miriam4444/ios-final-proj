//
//  Molecule.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//
import Foundation

struct Molecule: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var placedAtoms: [PlacedAtom]
    var bonds: [Bond]
    var dateCreated: Date
    
    init(id: UUID = UUID(), name: String, placedAtoms: [PlacedAtom] = [], bonds: [Bond] = [], dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.placedAtoms = placedAtoms
        self.bonds = bonds
        self.dateCreated = dateCreated
    }
}

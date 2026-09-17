//
//  MoleculeBuilderVM.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/1/25.
//
import Foundation
import SwiftUI

@Observable
class MoleculeBuilderVM {
    var placedAtoms: [PlacedAtom] = []
    var bonds: [Bond] = []
    var selectedBondType: BondType = .single
    var selectedAtomForBonding: PlacedAtom? = nil
    var currentMoleculeName: String = "New Molecule"
    
    //this is for adding atoms
    func addAtom(_ atom: Atom, at position: CGPoint) {
        let placedAtom = PlacedAtom(atom: atom, position: position)
        placedAtoms.append(placedAtom)
    }
    
    //this is for making it draggable
    func updateAtomPosition(_ atomId: UUID, to position: CGPoint) {
        if let index = placedAtoms.firstIndex(where: { $0.id == atomId }) {
            placedAtoms[index].position = position
        }
    }
    
    //the next few methods are gonna be the bond stuff
    func chooseAtomForBonding(_ placedAtom: PlacedAtom) {
        if let selected = selectedAtomForBonding {
            if selected.id != placedAtom.id {
                createBond(from: selected, to: placedAtom)
                selectedAtomForBonding = nil
            } else {
                selectedAtomForBonding = nil
            }
        } else {
            selectedAtomForBonding = placedAtom
        }
    }
    
    func createBond(from: PlacedAtom, to: PlacedAtom) {
        let bond = Bond(fromAtomId: from.id, toAtomId: to.id, type: selectedBondType)
        bonds.append(bond)
    }
    
    func deleteAtom(_ placedAtom: PlacedAtom) {
        bonds.removeAll { $0.fromAtomId == placedAtom.id || $0.toAtomId == placedAtom.id }
        placedAtoms.removeAll { $0.id == placedAtom.id }
    }
    
    func deleteBond(_ bond: Bond) {
        bonds.removeAll { $0.id == bond.id }
    }
    
    func clearWorkspace() {
        placedAtoms.removeAll()
        bonds.removeAll()
        selectedAtomForBonding = nil
        currentMoleculeName = "New Molecule"
    }
    
    func createMolecule() -> Molecule {
        return Molecule(
            name: currentMoleculeName,
            placedAtoms: placedAtoms,
            bonds: bonds,
            dateCreated: Date()
        )
    }
    //now im gonna load the molecule into the wrkspace
    func loadMolecule(_ molecule: Molecule) {
        currentMoleculeName = molecule.name
        placedAtoms = molecule.placedAtoms
        bonds = molecule.bonds
        selectedAtomForBonding = nil
    }
}

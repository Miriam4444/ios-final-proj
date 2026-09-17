//
//  AtomKeyboardView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct AtomKeyboardView: View {
    @Environment(\.dismiss) var dismiss
    let commonAtomSymbols: [String]
    let allAtoms: [Atom]
    var viewModel: MoleculeBuilderVM?
    
    var commonAtoms: [Atom] {
        return Atom.filterCommonAtoms(from: allAtoms)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    commonAtomsSection
                    Divider()
                    fullPeriodicTableSection
                }
                .padding()
            }
            .navigationTitle("Select Atom")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var commonAtomsSection: some View {
        VStack(spacing: 16) {
            Text("Common Atoms")
                .font(.title2)
                .bold()
            
            Text("Most frequently used in orgo")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if commonAtoms.isEmpty {
                ProgressView("Loading atoms...")
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                    ForEach(commonAtoms) { atom in
                        atomButton(atom: atom, isCommon: true)
                    }
                }
            }
        }
    }
    
    var fullPeriodicTableSection: some View {
        VStack(spacing: 16) {
            Text("All Elements")
                .font(.title2)
                .bold()
            
            Text("Scroll to find element")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if allAtoms.isEmpty {
                ProgressView("Loading periodic table...")
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 12) {
                    ForEach(allAtoms) { atom in
                        atomButton(atom: atom, isCommon: false)
                    }
                }
            }
        }
    }
    
    func atomButton(atom: Atom, isCommon: Bool) -> some View {
        Button(action: {
            let centerPoint = CGPoint(x: 200, y: 400)
            viewModel?.addAtom(atom, at: centerPoint)
            dismiss()
        }) {
            VStack(spacing: 4) {
                Text(atom.symbol)
                    .font(isCommon ? .title : .title3)
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: isCommon ? 70 : 60, height: isCommon ? 70 : 60)
                    .background(atomColor(for: atom.symbol))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(isCommon ? Color.yellow : Color.clear, lineWidth: 2)
                    )
                
                Text(atom.name)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                if isCommon {
                    Text("\(atom.number)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: isCommon ? 80 : 70)
        }
    }
    
    //im gonna make all the atoms a dif color now and apparently theres like some common colors associated with atoms so its basically:
    //noble gas: cyan
    //halogens: green
    //alkali metals: orange
    //alkaline earth metals: yellow
    //transition metals: rown
    //everything else: purple
    func atomColor(for symbol: String) -> Color {
        switch symbol {
        case "H": return Color.gray
        case "C": return Color.black
        case "N": return Color.blue
        case "O": return Color.red
        case "He": return Color.cyan
        case "F", "Cl", "Br", "I": return Color.green
        case "Li", "Na", "K", "Rb", "Cs", "Fr": return Color.orange
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra": return Color.yellow.opacity(0.7)
        case "Fe", "Co", "Ni", "Cu", "Zn": return Color.brown
        default: return Color.purple
        }
    }
}

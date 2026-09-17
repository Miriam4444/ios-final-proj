//
//  AtomDetailView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//
import SwiftUI

struct AtomDetailView: View {
    let atom: Atom
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text(atom.symbol)
                    .font(.system(size: 64, weight: .bold))
                
                Text(atom.name)
                    .font(.title)
                
                Text("Atomic Number: \(atom.number)")
                
                if let mass = atom.atomicMass {
                    Text("Atomic Mass: \(String(format: "%.3f", mass))")
                }
                
                if let density = atom.density {
                    Text("Density: \(density)")
                }
                
                if let category = atom.category {
                    Text(category.capitalized)
                        .italic()
                        .foregroundColor(.secondary)
                }
                
                if let appearance = atom.appearance {
                    Text("Appearance: \(appearance)")
                }
                
                if let summary = atom.summary {
                    Divider().padding(.vertical, 8)
                    Text(summary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(atom.symbol)
    }
}


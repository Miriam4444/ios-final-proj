//
//  SaveMoleculeDialog.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct SaveMoleculePopUp: View {
    @Binding var moleculeName: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Save Molecule")
                    .font(.title2)
                    .bold()
                
                TextField("Molecule Name", text: $moleculeName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    
                    Button("Save") {
                        onSave()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(moleculeName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

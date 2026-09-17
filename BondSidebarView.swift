//
//  BondSidebarView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/3/25.
//
import SwiftUI

struct BondSidebarView: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: MoleculeBuilderVM
    
    var body: some View {
        NavigationView {
            List {
                Section("Bond Types") {
                    ForEach(BondType.allCases, id: \.self) { bondType in
                        Button(action: {
                            viewModel.selectedBondType = bondType
                            dismiss()
                        }) {
                            HStack {
                                bondIcon(for: bondType)
                                Text(bondType.displayName)
                                    .foregroundColor(.primary)
                                Spacer()
                                if viewModel.selectedBondType == bondType {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                
                Section("Instructions") {
                    Text("1. Select a bond type")
                        .font(.caption)
                    Text("2. Tap two atoms to create a bond")
                        .font(.caption)
                }
            }
            .navigationTitle("Bonds")
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
    
    func bondIcon(for bondType: BondType) -> some View {
        HStack(spacing: 2) {
            switch bondType {
            case .single:
                Rectangle()
                    .frame(width: 30, height: 2)
            case .double:
                VStack(spacing: 2) {
                    Rectangle().frame(width: 30, height: 2)
                    Rectangle().frame(width: 30, height: 2)
                }
            case .triple:
                VStack(spacing: 2) {
                    Rectangle().frame(width: 30, height: 2)
                    Rectangle().frame(width: 30, height: 2)
                    Rectangle().frame(width: 30, height: 2)
                }
            }
        }
        .foregroundColor(.black)
    }
}

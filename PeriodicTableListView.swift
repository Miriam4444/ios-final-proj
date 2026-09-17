//
//  PeriodicTableListView.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//
import SwiftUI

struct PeriodicTableListView: View {
    @State private var viewModel = PeriodicTableVM()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading elements...")
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 8) {
                        Text("Error")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .padding()
                } else {
                    List(viewModel.elements) { atom in
                        NavigationLink(destination: AtomDetailView(atom: atom)) {
                            HStack {
                                Text("\(atom.number)")
                                    .font(.caption)
                                    .frame(width: 32, alignment: .leading)
                                
                                Text(atom.symbol)
                                    .font(.title2)
                                    .bold()
                                    .frame(width: 50, alignment: .leading)
                                
                                VStack(alignment: .leading) {
                                    Text(atom.name)
                                    if let category = atom.category {
                                        Text(category)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Periodic Table")
            .task {
                await viewModel.load()
            }
        }
    }
}

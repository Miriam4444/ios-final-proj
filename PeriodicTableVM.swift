//
//  PeriodicTableVM.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//
import Foundation

@Observable
class PeriodicTableVM {
    var elements: [Atom] = []
    var isLoading: Bool = false
    var errorMessage: String?
    
    @MainActor
    func load() async {
        if !elements.isEmpty { return }
        isLoading = true
        errorMessage = nil
        do {
            let atoms = try await PeriodicTableService.getAllElements()
            elements = atoms.sorted { $0.number < $1.number }
        } catch {
            print("Error:", error)
            errorMessage = "Failed to load elements."
        }
        isLoading = false
    }
}

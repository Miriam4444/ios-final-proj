//
//  Bond.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/24/25.
//
import Foundation

enum BondType: String, Codable, CaseIterable {
    case single
    case double
    case triple
    
    var displayName: String {
        switch self {
        case .single: return "Single"
        case .double: return "Double"
        case .triple: return "Triple"
        }
    }
}

struct Bond: Codable, Identifiable {
    var id: UUID = UUID()
    var fromAtomId: UUID
    var toAtomId: UUID
    var type: BondType
}

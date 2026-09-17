//
//  PlacedAtom.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/1/25.
//
import Foundation

//im using the CGPoint stuff so that each atom can have a unique place in the molecule area 

struct PlacedAtom: Codable, Identifiable {
    var id: UUID = UUID()
    var atom: Atom
    var position: CGPoint
    
    init(id: UUID = UUID(), atom: Atom, position: CGPoint) {
        self.id = id
        self.atom = atom
        self.position = position
    }
}

extension CGPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let x = try container.decode(CGFloat.self, forKey: .x)
        let y = try container.decode(CGFloat.self, forKey: .y)
        self.init(x: x, y: y)
    }
}

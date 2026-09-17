//
//  Note.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 12/1/25.
//
import Foundation

struct Note: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var content: String
    var dateCreated: Date
    var moleculeId: UUID?
    
    init(id: UUID = UUID(), title: String, content: String, dateCreated: Date = Date(), moleculeId: UUID? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.dateCreated = dateCreated
        self.moleculeId = moleculeId
    }
}

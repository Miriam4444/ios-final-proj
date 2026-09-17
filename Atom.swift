//
//  Atom.swift
//  MODELcule
//
//  Created by Miriam Abecasis on 11/21/25.
//
import Foundation

struct PeriodicTable: Codable {
    let elements: [Atom]
}

struct Atom: Codable, Identifiable, Equatable {
    var id: Int { number }
    let name: String
    let appearance: String?
    let atomicMass: Double?
    let boil: Double?
    let category: String?
    let density: Double?
    let symbol: String
    let number: Int
    let summary: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case appearance
        case atomicMass = "atomic_mass"
        case boil
        case category
        case density
        case symbol
        case number
        case summary
    }
}

// error stuff
enum PeriodicTableError: Error {
    case invalidURL
    case missingData
    case decodingFailed
}

// async await stuff
struct PeriodicTableService {
    
    static func getAllElements() async throws -> [Atom] {
        // here's my url, i just found an actual url instead of using postman like for themidterm i hope thats okay
        let periodicTableURL = "https://raw.githubusercontent.com/Bowserinator/Periodic-Table-JSON/master/PeriodicTableJSON.json"
        guard let url = URL(string: periodicTableURL) else {
            throw PeriodicTableError.invalidURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {
                throw PeriodicTableError.missingData
            }
            let decoder = JSONDecoder()
            let periodicTable = try decoder.decode(PeriodicTable.self, from: data)
            return periodicTable.elements
        } catch {
            print("Error fetching periodic table data: \(error)")
            throw PeriodicTableError.decodingFailed
        }
    }
}

extension Atom {
    //list the commonly used atoms (basically there are a few atoms that are like super common so i want them on top of my list of atoms so users dont have to scroll for them)
    static let commonAtoms = [1, 2, 6, 7, 8] // H, He, C, N, O
    
    //Because i have the common atoms on top i dont need them in the regularlist
    static func filterCommonAtoms(from allAtoms: [Atom]) -> [Atom] {
        return allAtoms.filter { commonAtoms.contains($0.number) }
            .sorted { $0.number < $1.number }
    }
    
    //get atom by symbol from a list
    static func getAtomBySymbol(_ symbol: String, in atoms: [Atom]) -> Atom? {
        return atoms.first { $0.symbol == symbol }
    }
}

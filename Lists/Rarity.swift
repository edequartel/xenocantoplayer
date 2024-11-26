//
//  Rarity.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//

enum Rarity: Int, CustomStringConvertible, CaseIterable {
    case all = 0 // Special case to include all rarities
    case common = 1
    case uncommon = 2
    case rare = 3
    case veryRare = 4

    // Computed property to provide a string representation
    var description: String {
        switch self {
        case .all:
            return "All"
        case .common:
            return "Comm"
        case .uncommon:
            return "Unc"
        case .rare:
            return "Rare"
        case .veryRare:
            return "Very"
        }
    }
}




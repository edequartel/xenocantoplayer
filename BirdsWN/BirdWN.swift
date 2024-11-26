//
//  BirdWN.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//
//  Model
//  File: BirdWN.swift

import Foundation

struct BirdWN: Codable, Identifiable {
    let id = UUID() // Unique identifier for SwiftUI
    let species: Int
    let group: Int
    let name: String
    let scientificName: String
    let rarity: Int
    let native: Bool
    let type: String
    let rank: Int
    let sortOrderGroup: Int
    let sortOrderRank: Int
    let sortOrderTaxonomy: Int

    enum CodingKeys: String, CodingKey {
        case species, group, name
        case scientificName = "scientific_name"
        case rarity, native, type, rank
        case sortOrderGroup = "sort_order_group"
        case sortOrderRank = "sort_order_rank"
        case sortOrderTaxonomy = "sort_order_taxonomy"
    }
}


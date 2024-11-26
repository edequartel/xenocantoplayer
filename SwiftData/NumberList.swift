//
//  SwiftDataModel.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//

import SwiftUI
import SwiftData

@Model
final class NumberList {
    @Attribute(.unique) var id: UUID
    var numbers: [Int]

    init(numbers: [Int] = []) {
        self.id = UUID()
        self.numbers = numbers
    }
}

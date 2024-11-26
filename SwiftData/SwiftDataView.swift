//
//  SwiftDataView.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//

import SwiftUI
import SwiftData

struct SwiftDataView: View {
  @Environment(\.modelContext) var modelContext
  @Query var species : [Species]

  var body: some View {
    NavigationStack {
      VStack {
        Button("delete 1111") {
          deleteSpeciesByNumber(1111)
        }
        List {
          ForEach(species) { species in
            VStack {
              Text("\(species.number)")
              Text(species.details)
              if checkSpeciesNumber(4444) {
                Text("X")
              } else {
                Text("O")
              }
            }
          }
          .onDelete(perform: deleteSpeciesNumber)
        }
        .toolbar {
          Button("add") {
            addSpeciesNumber(222)
          }
        }
      }
    }
  }

  func addSpeciesNumber(_ value: Int) {
    if !self.species.contains(where: { $0.number == value }) {
      modelContext.insert(Species(number: value))
      print("Inserted species with number \(value)")
    }
  }

  func deleteSpeciesNumber(_ indexSet: IndexSet) {
    for index in indexSet {
      let species = self.species[index]
      modelContext.delete(species)
      print("delete \(species)")
    }
  }

  func deleteSpeciesByNumber(_ number: Int) {
    if let species = self.species.first(where: { $0.number == number }) {
      modelContext.delete(species)
      print("delete byNumber \(species)")
    }
  }

  func checkSpeciesNumber(_ value: Int) -> Bool {
    return self.species.contains(where: { $0.number == value })
  }
}

#Preview {
  SwiftDataView()
}

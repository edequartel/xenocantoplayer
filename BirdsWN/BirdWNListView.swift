//
//  BirdWNListView.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//
//  File: BirdWNListView.swift

import SwiftUI
import SwiftData

struct BirdWNListView: View {
  @StateObject private var viewModel = BirdWNViewModel()
  @Environment(\.modelContext) var modelContext
  @Query var speciesList : [Species]

  @State private var searchText = "" // State to store search query
  @State private var isSortedAscending = true // State to track sort order
  @State private var selectedRarity: Rarity = .common // State to store selected rarity


  var groupedBirds: [String: [BirdWN]] {
    Dictionary(grouping: sortedBirds) { bird in
      String(bird.name.prefix(1)).uppercased() // Group by first letter of name
    }
  }


  var filteredBirds: [BirdWN] {
    viewModel.birds.filter { bird in
      let matchesSearchText = searchText.isEmpty ||
      bird.name.localizedCaseInsensitiveContains(searchText) ||
      bird.scientificName.localizedCaseInsensitiveContains(searchText)
      //        let matchesRarity = (bird.rarity == selectedRarity.rawValue) || (selectedRarity == .all)
      let speciesFavorite = true //checkSpeciesNumber(bird.species)
      return matchesSearchText && speciesFavorite // && matchesRarity
    }
  }


  var sortedBirds: [BirdWN] {
    filteredBirds.sorted {
      isSortedAscending
      ? $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
      : $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending
    }
  }

  var body: some View {
    NavigationStack {
      VStack {
        List {
          // Group sorted birds by the first letter of their names
          ForEach(groupedBirds.keys.sorted(), id: \.self) { letter in
            Section(header: Text(letter)) {
              ForEach(groupedBirds[letter] ?? [], id: \.id) { bird in
                HStack {
                  NavigationLink(destination: BirdListView(scientificName: bird.scientificName, nativeName: bird.name)) {
                    HStack {
                      VStack(alignment: .leading) {
                        HStack {
                          Text("\(bird.name)")
                            .font(.headline)
                          Spacer()
                          Text(checkSpeciesNumber(bird.species) ? "X" : "O")
                        }
                        Text(bird.scientificName)
                          .font(.subheadline)
                          .foregroundColor(.gray)
                          .italic()

                      }
                      Spacer()
                    }
                  }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false ) {
                  Button(action: {
                    addSpeciesNumber(bird.species)
                    //                              deleteSpeciesNumber(bird.species)
                  }) {
                    Image(systemName: "plus.circle")
                  }
                  .tint(.green)
                  Button(action: {
                    deleteSpeciesByNumber(bird.species)
                    printSpecies()
                  }) {
                    Image(systemName: "minus.circle")
                  }
                  .tint(.red)
                }
              }
            }
          }
        }
        .navigationTitle("Vogels")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Zoek naar vogels")
      }
    }
  }


  func addSpeciesNumber(_ value: Int) {
    if !speciesList.contains(where: { $0.number == value }) {
      let species = Species(number: value)
      modelContext.insert(species)
      print("Inserted species with number \(value)")
    }
  }

  func deleteSpeciesByNumber(_ number: Int) {
    if let species = speciesList.first(where: { $0.number == number }) {
      modelContext.delete(species)
      print("delete byNumber \(species)")
    }
  }

  func checkSpeciesNumber(_ value: Int) -> Bool {
    return speciesList.contains(where: { $0.number == value })
  }

  func printSpecies() {
    for species in speciesList {
      print(species.number)
    }
  }

}

//  var body: some View {
//    NavigationStack {
//      VStack {
//        List(sortedBirds) { bird in
//          NavigationLink(destination: BirdListView(scientificName: bird.scientificName, nativeName: bird.name)) {
//            HStack {
//              VStack(alignment: .leading) {
//                HStack{
//                  Text("\(bird.name)")
//                    .font(.headline)
//                }
//
//                Text(bird.scientificName)
//                  .font(.subheadline)
//                  .foregroundColor(.gray)
//                  .italic()
//              }
//              Spacer()
//            }
//          }
//        }
//        .navigationTitle("Vogels")
//        .navigationBarTitleDisplayMode(.inline)
//        .searchable(text: $searchText, prompt: "Zoek naar vogels")
//      }
//    }
//  }

//        // Picker for selecting rarity
//        Picker("Select Rarity", selection: $selectedRarity) {
//          ForEach(Rarity.allCases, id: \.self) { rarity in
//            Text(rarity.description).tag(rarity) // Use the string description
//          }
//        }
//        .pickerStyle(SegmentedPickerStyle()) // Use segmented style for better visuals
//        .padding()

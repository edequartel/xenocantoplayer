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
  @EnvironmentObject private var bookMarksViewModel: BookMarksViewModel
  @EnvironmentObject private var cacheMarksViewModel: BookMarksViewModel

  @State private var searchText = "" // State to store search query
  @State private var isSortedAscending = true // State to track sort order
  @State private var showFavorite = false // State to track sort order
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
      let speciesFavorite = bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) || !showFavorite
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
//        BookMarksView()
        List {
          // Group sorted birds by the first letter of their names
          ForEach(groupedBirds.keys.sorted(), id: \.self) { letter in
            Section(header: Text(letter)) {
              ForEach(groupedBirds[letter] ?? [], id: \.id) { bird in
                HStack {
                  NavigationLink(destination: BirdListView(scientificName: bird.scientificName, nativeName: bird.name)) {
                    BirdWNDetailView(bird: bird)
                  }
                }
                .padding()
                .background(
                    cacheMarksViewModel.isSpeciesIDInRecords(speciesID: stringToIntHash(bird.scientificName.lowercased()))
                    ? Color(.lightText) // Use UIColor for `.lightGray`
                        : Color.white
                )
                .cornerRadius(8) // Optional: Add rounded corners
                .shadow(radius: 2) // Optional: Add a shadow for better UI

                .swipeActions(edge: .trailing, allowsFullSwipe: false ) {
                  Button(action: {
                    if !bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) {
                      bookMarksViewModel.appendRecord(speciesID: bird.species)
                    } else {
                      bookMarksViewModel.removeRecord(speciesID: bird.species)
                    }
                  }) {
                    Image(systemName: bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) ? "star.fill" : "star")
                  }
                  .tint(.green)
                }
              }
            }
          }
        }
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
              showFavorite.toggle()
              print("Favorite toggled: \(showFavorite)")
            }) {
              Image(systemName: showFavorite ? "star.fill" : "star")
            }
          }

          ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination:  SettingsView()) {
              Image(systemName: "gearshape")
            }
            .accessibilityHint("Open website XC")
          }

        }
        .navigationTitle("Vogels")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Zoek naar vogels")
      }
    }
  }
}


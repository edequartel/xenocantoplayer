//
//  BirdWNListView.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//

import SwiftUI
import SFSafeSymbols

struct BirdWNListView: View {
  @Environment(\.colorScheme) var colorScheme // Detect system light/dark mode

  @StateObject private var viewModel = BirdWNViewModel()
  @EnvironmentObject private var bookMarksViewModel: BookMarksViewModel
  @EnvironmentObject private var cacheMarksViewModel: BookMarksViewModel

  @State private var searchText = "" // State to store search query
  @State private var isSortedAscending = true // State to track sort order
  @State private var showFavorite = false // State to track filter
  @State private var showDownloaded = false // State to track filter

  @State private var selectedFilterOption: FilterAllOption = .all
  @State private var selectedRarityOption: FilteringRarityOption = .all

  var groupedBirds: [String: [BirdWN]] {
    viewModel.groupedBirds()
  }

  var body: some View {
    NavigationStack {
      VStack {
        ShowView(title: "BirdWNListView")

        if viewModel.isLoading {
          ProgressView("Loading data...")
            .progressViewStyle(CircularProgressViewStyle())

        } else {
          List {
            ForEach(groupedBirds.keys.sorted(), id: \.self) { letter in
              Section(header: Text(letter)) {
                ForEach(groupedBirds[letter] ?? [], id: \.id) { bird in
                  HStack {
                    NavigationLink(destination: BirdListView(scientificName: bird.scientificName, nativeName: bird.name)) {
                      BirdWNDetailView(bird: bird)
                    }
                  }
                  .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(action: {
                      toggleFavorite(for: bird)
                    }) {
                      Image(systemName: bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) ? "star.fill" : "star")
                    }
                    .tint(.green)

                    Button(action: {
                      cacheMarksViewModel.removeRecord(speciesID: stringToIntHash(bird.scientificName.lowercased()))
                    }) {
                      Image(systemName: "arrow.down.circle.fill")
                    }
                    .tint(.red)
                  }
                }
              }
            }
          }


          .listStyle(.plain)
          .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
              Button(action: {
                showFavorite.toggle()
              }) {
                Image(systemName: showFavorite ? "star.fill" : "star")
                  .accessibilityLabel(Text(showFavorite ? "Favorite filter on" : "Favorite filter off"))
              }
            }

            ToolbarItem(placement: .navigationBarLeading) {
              Button(action: {
                showDownloaded.toggle()
              }) {
                Image(systemName: showDownloaded ? "arrow.down.circle.fill" : "arrow.down.circle")
                  .accessibilityLabel(Text(showDownloaded ? "Downloaded filter on" : "Downloaded filter off"))
              }
            }

//            ToolbarItem(placement: .navigationBarTrailing) {
//              NavigationLink(destination: SortFilterSpeciesView(
//                selectedFilterAllOption: $selectedFilterOption,
//                selectedRarityOption: $selectedRarityOption
//              )) {
//                Image(systemSymbol: .ellipsisCircle)
//              }
//            }

          }
          .navigationTitle("Birds")
          .navigationBarTitleDisplayMode(.inline)
          .searchable(text: $searchText, prompt: "Search for bird")
        }
      }
    }


//    .onChange(of: selectedFilterOption) { newValue, oldvalue in
//      viewModel.filterBirds(
//        searchText: searchText,
//        showFavorite: showFavorite,
//        showDownloaded: showDownloaded,
//        showFilterAll: newValue,
//        bookMarksViewModel: bookMarksViewModel,
//        cacheMarksViewModel: cacheMarksViewModel
//      )
//    }

    .onChange(of: searchText) { newValue, oldvalue in
      viewModel.filterBirds(
        searchText: newValue,
        showFavorite: showFavorite,
        showDownloaded: showDownloaded,
        showFilterAll: selectedFilterOption,
        bookMarksViewModel: bookMarksViewModel,
        cacheMarksViewModel: cacheMarksViewModel
      )
    }

    .onChange(of: showFavorite) { newValue, oldvalue in
      viewModel.filterBirds(
        searchText: searchText,
        showFavorite: showFavorite,
        showDownloaded: showDownloaded,
        showFilterAll: selectedFilterOption,
        bookMarksViewModel: bookMarksViewModel,
        cacheMarksViewModel: cacheMarksViewModel
      )
    }

    .onChange(of: showDownloaded) { newValue, oldvalue in
      viewModel.filterBirds(
        searchText: searchText,
        showFavorite: showFavorite,
        showDownloaded: showDownloaded,
        showFilterAll: selectedFilterOption,
        bookMarksViewModel: bookMarksViewModel,
        cacheMarksViewModel: cacheMarksViewModel
      )
    }

    .onChange(of: isSortedAscending) { newValue, oldvalue in
      viewModel.sortBirds(ascending: isSortedAscending)
    }
  }

  /// Toggles the favorite status of a bird
  private func toggleFavorite(for bird: BirdWN) {
    if bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) {
      bookMarksViewModel.removeRecord(speciesID: bird.species)
    } else {
      bookMarksViewModel.appendRecord(speciesID: bird.species)
    }
  }
}



//
//  BirdWNViewModel.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//

import Foundation
import Combine

class BirdWNViewModel: ObservableObject {
    @Published var birds: [BirdWN] = []
    @Published var isLoading: Bool = false
    @Published var filteredBirds: [BirdWN] = [] // Stores filtered results for efficiency
    private let jsonFileName = "dutch.json"

    init() {
        loadBirds()
    }

    /// Loads birds from a JSON file asynchronously
    private func loadBirds() {
        isLoading = true

        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: nil) else {
            print("Failed to locate \(jsonFileName) in bundle.")
            isLoading = false
            return
        }

        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                let decodedBirds = try JSONDecoder().decode([BirdWN].self, from: data)

                DispatchQueue.main.async {
                    self.birds = decodedBirds
                    self.filteredBirds = decodedBirds // Initialize filtered data
                    self.isLoading = false
                }
            } catch {
                print("Failed to load and decode JSON: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }

    /// Filters birds based on search text, favorite filter, and downloaded filter
    func filterBirds(searchText: String,
                     showFavorite: Bool,
                     showDownloaded: Bool,
                     showFilterAll: FilterAllOption,
                     bookMarksViewModel: BookMarksViewModel,
                     cacheMarksViewModel: BookMarksViewModel) {
      DispatchQueue.global(qos: .userInitiated).async {
        let filtered = self.birds.filter { bird in
          let matchesSearchText = searchText.isEmpty ||
          bird.name.localizedCaseInsensitiveContains(searchText) ||
          bird.scientificName.localizedCaseInsensitiveContains(searchText)

          let isFavorite = bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) || !showFavorite
          let isDownloaded = cacheMarksViewModel.isSpeciesIDInRecords(speciesID: stringToIntHash(bird.scientificName.lowercased())) || !showDownloaded

          let isAll = (bird.native) // && showFilterAll == .native) || (showFilterAll == .all)
          let isRarity = (bird.rarity != 4)

          return matchesSearchText && isFavorite && isDownloaded && isAll && isRarity
        }

        DispatchQueue.main.async {
          self.filteredBirds = filtered
        }
      }
    }

    /// Sorts birds in ascending or descending order
    func sortBirds(ascending: Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            let sorted = self.filteredBirds.sorted {
                ascending
                ? $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                : $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending
            }

            DispatchQueue.main.async {
                self.filteredBirds = sorted
            }
        }
    }

    /// Groups birds by the first letter of their name
    func groupedBirds() -> [String: [BirdWN]] {
        Dictionary(grouping: filteredBirds) { bird in
            String(bird.name.prefix(1)).uppercased()
        }
    }
}



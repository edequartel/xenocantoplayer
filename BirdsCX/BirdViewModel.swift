//
//  ViewModel.swift
//  XC
//
//  Created by Eric de Quartel on 25/11/2024.
//
import SwiftUI
import Alamofire

class BirdViewModel: ObservableObject {

  @Published var birds: [Bird] = []
  @Published var totalRecordings: Int = 0
  @Published var totalPages: Int = 0
  @Published var currentPage: Int = 0
  @Published var totalSpecies: Int = 0
  @Published var isLoading = false
  @Published var errorMessage: String?

  var hasFetchedBirds: Bool = false // New flag to track fetch status


  func fetchBirds(name: String, clearCache: Bool = false) {
    let checkedName = name.lowercased().replacingOccurrences(of: " ", with: "+")
    let url = "https://xeno-canto.org/api/2/recordings?query=\(checkedName)"
    let cacheKey = name
    isLoading = true
    errorMessage = nil

    // Optionally clear the cache
    if clearCache {
      UserDefaults.standard.removeObject(forKey: cacheKey)
    }

    // Check cache first
    if let cachedData = UserDefaults.standard.data(forKey: cacheKey),
       let birdResponse = try? JSONDecoder().decode(BirdResponse.self, from: cachedData) {
      DispatchQueue.main.async {
        self.isLoading = false
        self.birds = birdResponse.recordings
        self.totalRecordings = Int(birdResponse.numRecordings) ?? 0
        self.totalPages = birdResponse.numPages
        self.currentPage = birdResponse.page
        self.totalSpecies = Int(birdResponse.numSpecies) ?? 0
      }
      self.hasFetchedBirds = true // Mark as fetched
      return
    }

    AF.request(url).responseDecodable(of: BirdResponse.self) { response in
      DispatchQueue.main.async {
        self.isLoading = false
        switch response.result {
        case .success(let birdResponse):
          self.birds = birdResponse.recordings
          self.totalRecordings = Int(birdResponse.numRecordings) ?? 0
          self.totalPages = birdResponse.numPages
          self.currentPage = birdResponse.page
          self.totalSpecies = Int(birdResponse.numSpecies) ?? 0

          // Cache the response data
          if let dataToCache = try? JSONEncoder().encode(birdResponse) {
            UserDefaults.standard.set(dataToCache, forKey: cacheKey)
          }

          self.hasFetchedBirds = true // Mark as fetched
        case .failure(let error):
          self.errorMessage = "Failed to fetch birds: \(error.localizedDescription)"
        }
      }
    }
  }

  func clearCache(for name: String) {
      let cacheKey = name
      UserDefaults.standard.removeObject(forKey: cacheKey)
  }
}

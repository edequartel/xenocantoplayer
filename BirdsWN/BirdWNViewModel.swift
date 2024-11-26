//
//  BirdWNVidwModel.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//
//  BirdWNViewModel
//  File: BirdViewModel.swift

import Foundation

class BirdWNViewModel: ObservableObject {
    @Published var birds: [BirdWN] = []
    private let jsonFileName = "dutch.json"

    init() {
        loadBirds()
    }

    private func loadBirds() {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: nil) else {
            print("Failed to locate \(jsonFileName) in bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decodedBirds = try JSONDecoder().decode([BirdWN].self, from: data)
            DispatchQueue.main.async {
                self.birds = decodedBirds
            }
        } catch {
            print("Failed to load and decode JSON: \(error)")
        }
    }
}


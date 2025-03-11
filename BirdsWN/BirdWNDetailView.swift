//
//  jsonModel.swift
//  XC
//
//  Created by Eric de Quartel on 25/11/2024.
//
//  File: BirdDetailView.swift

import SwiftUI

struct BirdWNDetailView: View {
  @EnvironmentObject private var bookMarksViewModel: BookMarksViewModel
  @EnvironmentObject private var cacheMarksViewModel: BookMarksViewModel

  let bird: BirdWN

  var accessibilityLabel: String {
    var label = "\(bird.name),"
    label += " \(bird.scientificName),"

    if cacheMarksViewModel.isSpeciesIDInRecords(speciesID: stringToIntHash(bird.scientificName.lowercased())) {
      label += " downloaded,"
    }

    if bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) {
      label += " favoriet."
    }

    return label
  }

  var body: some View {
    VStack {
      ShowView(title: "BirdWNDetailView")
      HStack {
        VStack(alignment: .leading) {
          HStack {
            Image(systemName: "circle.fill")
              .foregroundColor(rarityColor(value: bird.rarity))

//            Text("\(bird.rarity)")
            
            if cacheMarksViewModel.isSpeciesIDInRecords(speciesID: stringToIntHash(bird.scientificName.lowercased())) {
              Image(systemName: "arrow.down.circle.fill")
                .foregroundColor(.gray)
            }

            Text("\(bird.name)")
              .font(.headline)

            Spacer()
            if bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) {
              Image(systemName: "star.fill")
                .foregroundColor(.gray)
            }
          }
          Text(bird.scientificName)
            .font(.subheadline)
            .foregroundColor(.gray)
            .italic()
        }
        Spacer()
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel(accessibilityLabel)
  }
}

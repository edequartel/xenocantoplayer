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

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Text("\(bird.name)")
            .font(.headline)
          Spacer()
          if bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) {
              Image(systemName: "star.fill")
          }
//          if cacheMarksViewModel.isSpeciesIDInRecords(speciesID: stringToIntHash(bird.scientificName.lowercased())) {
//              Image(systemName: "circle.fill")
//              .foregroundColor(.blue)
//          }
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



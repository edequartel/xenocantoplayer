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
    VStack {
      ShowView(title: "BirdWNDetailView")
      HStack {
        VStack(alignment: .leading) {
          HStack {
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

//                .foregroundColor(.blue)
//            }
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
}



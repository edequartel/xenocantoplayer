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

  let bird: BirdWN

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        HStack {
          Text("\(bird.name)")
            .font(.headline)
          Spacer()
          Image(systemName: bookMarksViewModel.isSpeciesIDInRecords(speciesID: bird.species) ? "star.fill" : "")
        }
        Text(bird.scientificName)
          .font(.subheadline)
          .foregroundColor(.gray)
          .italic()

//        if bird.checked { Image("star.fill") }
      }
      Spacer()
    }
  }
}



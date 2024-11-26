//
//  jsonModel.swift
//  XC
//
//  Created by Eric de Quartel on 25/11/2024.
//
//  File: BirdDetailView.swift

import SwiftUI

struct BirdWNDetailView: View {
    let bird: BirdWN

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(bird.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("\(bird.scientificName)")
            .italic()

                .font(.title2)

//            Text("Rarity: \(bird.rarity)")
//                .font(.body)
//
//            Text("Native: \(bird.native ? "Yes" : "No")")
//                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle(bird.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}



// File: XenoCantoAPI.swift

import SwiftUI
import Alamofire
import Kingfisher
import AVFoundation

// MARK: - View
struct BirdListView: View {
  @StateObject private var viewModel = BirdViewModel()
  @EnvironmentObject private var cacheMarksViewModel: BookMarksViewModel

  let scientificName: String
  var nativeName: String?

  @State private var selectedBird: Bird?

  var body: some View {
    VStack {
      ShowView(title: "BirdListView")
      Group {
        if viewModel.isLoading {
          ProgressView("Loading data...")
            .progressViewStyle(CircularProgressViewStyle())

        } else if let errorMessage = viewModel.errorMessage {
          Text("Error: \(errorMessage)")
        } else {
          VStack {
            List(viewModel.birds.filter { isMP3(filename: $0.fileName ?? "") }) { bird in
              Text(bird.loc ?? "")
                .onTapGesture {
                  selectedBird = bird // Set selected bird to show sheet
                }
                .navigationTitle("\(nativeName ?? "")")
            }
            .listStyle(.plain)
          }
          .sheet(item: $selectedBird) { bird in
            BirdDetailView(bird: bird, nativeName: nativeName)
              .presentationDetents([.fraction(0.6)]) // Enables swipe-down to dismiss
              .presentationDragIndicator(.visible) // Shows a handle at the top
          }
        }
      }
    }


    .onAppear {
      //      if !viewModel.hasFetchedBirds {
      if !cacheMarksViewModel.isSpeciesIDInRecords(speciesID: stringToIntHash(scientificName.lowercased())) {
        viewModel.fetchBirds(name: scientificName, clearCache: true, onComplete: {
          cacheMarksViewModel.appendRecord(speciesID: stringToIntHash(scientificName.lowercased()))
        })
        //        cacheMarksViewModel.appendRecord(speciesID: stringToIntHash(scientificName.lowercased()))
      }
      else {
        viewModel.fetchBirds(name: scientificName, clearCache: false)
      }
    }
  }



  func isMP3(filename: String) -> Bool {
    let pattern = #"^.+\.mp3$"# // Regex pattern to match filenames ending with .mp3
    if let _ = filename.range(of: pattern, options: .regularExpression) {
      return true
    }
    return false
  }
}


// MARK: - Preview
struct BirdListView_Previews: PreviewProvider {
  static var previews: some View {
    BirdListView(scientificName: "Limosa limosa", nativeName: "Grutto")
  }
}



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

  var body: some View {
    Group {
      if viewModel.isLoading {
        ProgressView("Loading data...")
          .progressViewStyle(CircularProgressViewStyle())

      } else if let errorMessage = viewModel.errorMessage {
        Text("Error: \(errorMessage)")
      } else {
        VStack {
          List(viewModel.birds.filter { isMP3(filename: $0.fileName ?? "") }) { bird in
            NavigationLink(destination: BirdDetailView(bird: bird, nativeName: nativeName)) {
              HStack {
                Text(bird.loc ?? "")
              }
            }
          }
        }
      }
    }

    .onAppear {
      if !viewModel.hasFetchedBirds {
        viewModel.fetchBirds(name: scientificName, clearCache: false)
        cacheMarksViewModel.appendRecord(speciesID: stringToIntHash(scientificName.lowercased()))
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



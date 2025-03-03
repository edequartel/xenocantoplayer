// File: XenoCantoAPI.swift

import SwiftUI
import Alamofire
import Kingfisher
import AVFoundation

let creativeCommonsLicenses: [String: String] = [
    "//creativecommons.org/licenses/by-nc/2.5/": "CC BY",
    "//creativecommons.org/licenses/by-nc-sa/2.5/": "CC BY-SA",
    "//creativecommons.org/licenses/by-nc-nd/2.5/": "CC BY-ND",
    "//creativecommons.org/licenses/by-nc-nc/2.5/": "CC BY-NC",
    "//creativecommons.org/licenses/by-nc-sa/4.0/": "CC BY-NC-SA",
    "//creativecommons.org/licenses/by-nc-nd/4.0/": "CC BY-NC-ND"
]

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
              VStack {
                HStack {
                  Text("\(bird.q ?? "")")
                    .font(.caption)
                  Text("\(bird.type ?? "")")
                    .font(.caption)
                  Text("# \(bird.id)")
                    .font(.caption)
                  Spacer()
                }
                HStack {
                  Text("\(bird.rec ?? "")")
                    .font(.caption)
//                  Text("\(bird.lic ?? "")")
//                    .font(.caption)
                  Text(creativeCommonsLicenses[bird.lic ?? ""] ?? "Unknown License")
                    .font(.caption)
                  Spacer()
                }
              }
                .onTapGesture {
                  print(bird.lic ?? "")
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



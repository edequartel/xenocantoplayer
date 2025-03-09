// File: XenoCantoAPI.swift

import SwiftUI
import Alamofire
import Kingfisher
import AVFoundation
import SwiftAudioEx

let creativeCommonsLicenses: [String: String] = [
  "//creativecommons.org/licenses/by-nc/2.5/": "CC BY",
  "//creativecommons.org/licenses/by-nc-sa/2.5/": "CC BY-SA",
  "//creativecommons.org/licenses/by-nc-nd/2.5/": "CC BY-ND",
  "//creativecommons.org/licenses/by-nc-nc/2.5/": "CC BY-NC",
  "//creativecommons.org/licenses/by-nc-sa/4.0/": "CC BY-NC-SA",
  "//creativecommons.org/licenses/by-nc-nd/4.0/": "CC BY-NC-ND"
]

// MARK: - BirdListView
struct BirdListView: View {
  @StateObject private var viewModel = BirdViewModel()
  @EnvironmentObject private var cacheMarksViewModel: BookMarksViewModel
  @State private var typeSound: String = "mixed"
  @StateObject private var audioPlayerManager = AudioPlayerManager()
  @State private var currentlyPlayingBirdID: String? = nil
  @State private var selectedBird: Bird?
  
  let scientificName: String
  var nativeName: String?
  
  var body: some View {
    VStack {
      ShowView(title: "BirdListView")
      SoundTypePickerView(typeSound: $typeSound)
      Group {
        if viewModel.isLoading {
          ProgressView("Loading data...")
            .progressViewStyle(CircularProgressViewStyle())
        } else if let errorMessage = viewModel.errorMessage {
          Text("Error: \(errorMessage)")
        } else {
          VStack {
            List(viewModel.birds.filter {
              isMP3(filename: $0.fileName ?? "") &&
              ($0.type == typeSound || typeSound == "mixed")
            }) { bird in
              BirdRowView(
                bird: bird,
                audioPlayerManager: audioPlayerManager,
                currentlyPlayingBirdID: $currentlyPlayingBirdID
              )
              .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button(action: {
                  selectedBird = bird
                }) {
                  Label("Info", systemImage: "info.circle")
                }
              }
            }
            .listStyle(PlainListStyle())
          }
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          print("filter")
        }) {
          Image(systemSymbol: .rectangle2Swap)
        }
        .accessibility(label: Text("Switch view"))
      }
    }
    .sheet(item: $selectedBird) { bird in
      BirdDetailView(bird: bird, nativeName: nativeName)
        .presentationDetents([.fraction(0.3)]) // Enables swipe-down to dismiss
        .presentationDragIndicator(.visible) // Shows a handle at the top
    }
    .onAppear {
      if !cacheMarksViewModel.isSpeciesIDInRecords(speciesID: stringToIntHash(scientificName.lowercased())) {
        viewModel.fetchBirds(name: scientificName, clearCache: true, onComplete: {
          cacheMarksViewModel.appendRecord(speciesID: stringToIntHash(scientificName.lowercased()))
        })
      } else {
        viewModel.fetchBirds(name: scientificName, clearCache: false)
      }
    }
  }
  
  func isMP3(filename: String) -> Bool {
    let pattern = #"^.+\.mp3$"#
    return filename.range(of: pattern, options: .regularExpression) != nil
  }
}



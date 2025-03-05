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
  @State private var typeSound: String = "mixed"

  let scientificName: String
  var nativeName: String?

  @State private var selectedBird: Bird?

  var body: some View {
    VStack {
      ShowView(title: "BirdListView")
      HStack {
        SoundTypePickerView(typeSound: $typeSound)
        Spacer()
      }
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
              VStack {
                HStack {
                  Text("\(bird.q ?? "")")
                    .font(.caption)
                  Text("\(bird.type ?? "")")
                    .font(.caption)
                  Text("XC\(bird.id)")
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
              .frame(height: 40)

              .swipeActions(edge: .leading, allowsFullSwipe: false ) {
                Button(action: {
                  print("XC")
                  if let url = modifyURL(from: bird.url) {
                      UIApplication.shared.open(url)
                  } else {
                      print("Invalid URL")
                  }
                }) {
                  Text("XC")
                }
              }

              .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                  Button(action: {
                    selectedBird = bird
                  }) {
                      Label("Info", systemImage: "info.circle")
                  }
              }


              .onTapGesture {
                print("play or pause the bird sound")
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

    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          print("filter")
        }) {
          Image(systemSymbol: .rectangle2Swap) // Replace with your desired image
          //            .uniformSize()
        }
        .accessibility(label: Text("Switch view"))
      }
    }



    .onAppear {
      if !cacheMarksViewModel.isSpeciesIDInRecords(speciesID: stringToIntHash(scientificName.lowercased())) {
        viewModel.fetchBirds(name: scientificName, clearCache: true, onComplete: {
          cacheMarksViewModel.appendRecord(speciesID: stringToIntHash(scientificName.lowercased()))
        })
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


struct SoundTypePickerView: View {
  @Binding var typeSound: String

  let soundOptions = ["mixed","call", "song", "alarm call", "flight call", "night calls", "begging calls"]

  var body: some View {
    //        VStack {
    Picker("Sound Type", selection: $typeSound) {
      ForEach(soundOptions, id: \.self) { sound in
        Text(sound).tag(sound)
      }
    }
    .pickerStyle(.menu) // Menu style picker
    //        }
  }
}


// MARK: - Preview
struct BirdListView_Previews: PreviewProvider {
  static var previews: some View {
    BirdListView(scientificName: "Limosa limosa", nativeName: "Grutto")
  }
}



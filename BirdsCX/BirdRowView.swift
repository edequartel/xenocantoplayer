//
//  BirdRowView.swift
//  XC
//
//  Created by Eric de Quartel on 07/03/2025.
//

import SwiftUI
import Alamofire
import Kingfisher
import AVFoundation
import SwiftAudioEx

// MARK: - BirdRowView
struct BirdRowView: View {
    let bird: Bird
    @ObservedObject var audioPlayerManager: AudioPlayerManager
    @Binding var currentlyPlayingBirdID: String?
    @State private var isLoadingAudio = false

    var isPlayingThisBird: Bool {
        currentlyPlayingBirdID == bird.id && audioPlayerManager.isPlaying
    }

    var body: some View {
        Button(action: {
            if isPlayingThisBird {
                audioPlayerManager.stopAudio()
                currentlyPlayingBirdID = nil
                isLoadingAudio = false
            } else {
                if currentlyPlayingBirdID != nil {
                    audioPlayerManager.stopAudio()
                }
                currentlyPlayingBirdID = bird.id
                isLoadingAudio = true
                audioPlayerManager.playAudio(from: bird.file) {
                    isLoadingAudio = false
                }
            }
        }) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    VStack {
                        HStack {
                            Image(systemName: "\(bird.q?.lowercased() ?? "").square.fill")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("XC\(bird.id)")
                                .font(.caption)
                                .bold(true)
                            Text("\(bird.type ?? "")")
                                .font(.caption)
                            Spacer()
                        }
                        HStack {
                            Text("\(bird.rec ?? "")")
                                .font(.caption)
                            Text(creativeCommonsLicenses[bird.lic ?? ""] ?? "Unknown License")
                                .font(.caption)
                            Spacer()
                        }
                    }
                    Spacer()
                    if isLoadingAudio {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if isPlayingThisBird {
                        Image(systemName: "waveform")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 40)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: {
                if let url = modifyURL(from: bird.url) {
                    UIApplication.shared.open(url)
                } else {
                    print("Invalid URL")
                }
            }) {
                Text("XC")
            }
        }
        .accessibilityElement(children: .combine)
    }
}

// MARK: - AudioPlayerManager
class AudioPlayerManager: ObservableObject {
    let player = AudioPlayer()
    @Published var isPlaying: Bool = false

    init() {
        player.event.stateChange.addListener(self) { [weak self] state in
            DispatchQueue.main.async {
                self?.isPlaying = state == .playing
            }
        }
    }

    func playAudio(from urlString: String?, completion: (() -> Void)? = nil) {
        print("playAudio \(String(describing: urlString))")
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Invalid URL")
            completion?()
            return
        }

        let audioItem = DefaultAudioItem(audioUrl: url.absoluteString, sourceType: .stream)
        player.load(item: audioItem, playWhenReady: true)

        // Call completion when the audio starts playing
        player.event.stateChange.addListener(self) { [weak self] state in
            DispatchQueue.main.async {
                if state == .playing {
                    self?.isPlaying = true
                    completion?()
                }
            }
        }
    }

    func stopAudio() {
        print("stopAudio")
        player.stop()
    }
}

// MARK: - BirdRowView
//struct BirdRowView: View {
//  let bird: Bird
//  @ObservedObject var audioPlayerManager: AudioPlayerManager
////  @EnvironmentObject  var accessibilityManager: AccessibilityManager
//  @Binding var currentlyPlayingBirdID: String?
//
//  var isPlayingThisBird: Bool {
//    currentlyPlayingBirdID == bird.id && audioPlayerManager.isPlaying
//  }
//
//  var body: some View {
//    Button(action: {
//      if isPlayingThisBird {
//        audioPlayerManager.stopAudio()
//        currentlyPlayingBirdID = nil
//      } else {
//        if currentlyPlayingBirdID != nil {
//          audioPlayerManager.stopAudio()
//        }
//        currentlyPlayingBirdID = bird.id
//        audioPlayerManager.playAudio(from: bird.file)
//      }
//    }) {
//      VStack(alignment: .leading, spacing: 5) {
//        HStack {
//          VStack {
//            HStack {
//              Image(systemName: "\(bird.q?.lowercased() ?? "").square.fill")
//                .font(.caption)
//                .foregroundColor(.gray)
//
//
//              Text("XC\(bird.id)")
//                .font(.caption)
//                .bold(true)
//
//              Text("\(bird.type ?? "")")
//                .font(.caption)
//              
//              Spacer()
//            }
//            HStack {
//              Text("\(bird.rec ?? "")")
//                .font(.caption)
//
//              Text(creativeCommonsLicenses[bird.lic ?? ""] ?? "Unknown License")
//                .font(.caption)
//              Spacer()
//            }
//          }
//          Spacer()
//          if isPlayingThisBird {
//            Image(systemName: "waveform")
//              .font(.title)
//              .foregroundColor(.gray)
//          }
//        }
//      }
//      .frame(maxWidth: .infinity, minHeight: 40) // Ensures full row is tappable
//      .padding(.horizontal, 10)
//      .padding(.vertical, 4)
//      .contentShape(Rectangle()) // Ensures whole area is tappable
//
//    }
//
//    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//      Button(action: {
//        if let url = modifyURL(from: bird.url) {
//          UIApplication.shared.open(url)
//        } else {
//          print("Invalid URL")
//        }
//      }) {
//        Text("XC")
//      }
//    }
//    .accessibilityElement(children: .combine)
//  }
//}


// MARK: - AudioPlayerManager
//class AudioPlayerManager: ObservableObject {
//  let player = AudioPlayer()
//  @Published var isPlaying: Bool = false
//
//  init() {
//    player.event.stateChange.addListener(self) { [weak self] state in
//      DispatchQueue.main.async {
//        self?.isPlaying = state == .playing
//      }
//    }
//  }
//
//  func playAudio(from urlString: String?) {
//    print("playAudio \(String(describing: urlString))")
//    guard let urlString = urlString, let url = URL(string: urlString) else {
//      print("Invalid URL")
//      return
//    }
//    let audioItem = DefaultAudioItem(audioUrl: url.absoluteString, sourceType: .stream)
//    player.load(item: audioItem, playWhenReady: true)
//  }
//
//  func stopAudio() {
//    print("stopAudio")
//    player.stop()
//  }
//}

// MARK: - SoundTypePickerView
struct SoundTypePickerView: View {
  @Binding var typeSound: String

  let soundOptions = ["mixed", "call", "song", "alarm call", "flight call", "night calls", "begging calls"]

  var body: some View {
    HStack {
      Picker("Select", selection: $typeSound) {
        ForEach(soundOptions, id: \.self) { sound in
          Text(sound).tag(sound)
        }
      }
      .pickerStyle(.navigationLink)
    }
    .padding()
  }
}

// MARK: - Preview
struct BirdListView_Previews: PreviewProvider {
  static var previews: some View {
    BirdListView(scientificName: "Limosa limosa", nativeName: "Grutto")
  }
}

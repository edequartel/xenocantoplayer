//
//  SoundsView.swift
//  XC
//
//  Created by Eric de Quartel on 26/11/2024.
//
//
//  ContentView.swift
//  TestSoundableStream
//
//  Created by Eric de Quartel on 20/03/2024.
//
import SwiftUI

struct PlayerControlsView: View {
  @EnvironmentObject var player: Player

  @Environment(\.presentationMode) var presentationMode

  @State private var sliderValue: Double = 0
  @State private var nrPlaying = 0

  var sounds: [String]
  let length: String

  var body: some View {
    if !(sounds.isEmpty) {

      VStack {
        VStack {
          if sounds.count > 1 {
            HStack {
              Spacer()
              Text("\(player.currentIndex+1)-\(sounds.count)")
            }
            .font(.caption)
            .foregroundColor(.gray)
          }

          let endOf = Double(timeStringToSeconds(length))
          Slider(value: $player.currentTime, in: 0...endOf)
            .disabled(true)

          HStack {
            Text(String(format: "%.2f", player.currentTime))
            Spacer()
//            Text(String(format: "%.2f", player.duration))
//            Text("\(timeStringToSeconds(length))")
            Text("\(length)")

          }
          .font(.caption)
          .foregroundColor(.gray)

        }

        HStack {
          Spacer()

          if sounds.count > 1 {
            Button(action: {
              player.previous()
              player.play()
            }) {
              Image(systemName: "backward.end.circle.fill")
                .font(.system(size: 30))
                .frame(width: 50)
            }
          }

          if player.status != .playing
          {
            Button(action: {
              player.play()
            }) {
              Image(systemName: "play.circle.fill")
                .font(.system(size: 50))
                .frame(width: 50)
            }
          } else {
            Button(action: {
              player.pause()
            }) {
              Image(systemName: "pause.circle.fill")
                .font(.system(size: 50))
                .frame(width: 50)
            }
          }

          if (sounds.count > 1) {
            Button(action: {
              player.next()
              player.play()
            }) {
              Image(systemName: "forward.end.circle.fill")
                .font(.system(size: 30))
                .frame(width: 50)
            }
          }
          Spacer()
        }
        .padding(10)
      }
      .onAppear {
        player.fill(sounds)
      }
      .onDisappear {
        player.stop()
      }
    }
  }




  private var closeButton: some View {
    Button {
      presentationMode.wrappedValue.dismiss()
    } label: {
      Image(systemName: "xmark")
        .font(.headline)
    }
    .buttonStyle(.bordered)
    .clipShape(Circle())
    .padding()
  }

  func timeStringToSeconds(_ timeString: String) -> Int {
    let components = timeString.split(separator: ":").compactMap { Int($0) }
    guard components.count == 2 else {
        return 0 // Return 0 for invalid input
    }
    let minutes = components[0]
    let seconds = components[1]

    return (minutes * 60) + seconds
  }
}

struct PlayerControlsView_Previews: PreviewProvider {
  static var previews: some View {
    PlayerControlsView(sounds: [], length: "01:00")
      .environmentObject(Player())
  }
}

//struct ContentView: View {
//    @EnvironmentObject var player: Player
//
//    var audio1 = ["https://waarneming.nl/media/sound/235291.mp3",
//                  "https://waarneming.nl/media/sound/235292.mp3",
//                  "https://waarneming.nl/media/sound/235293.mp3"]
//
//    var audio2 = ["https://waarneming.nl/media/sound/235783.wav",
//                  "https://waarneming.nl/media/sound/235293.mp3",
//                  "https://waarneming.nl/media/sound/235770.mp3"]
//
//    var audio3 = ["https://waarneming.nl/media/sound/235783.wav",
//                  "https://waarneming.nl/media/sound/235293.mp3",
//                  "https://waarneming.nl/media/sound/235770.mp3"]
//
//
//    var body: some View {
//        VStack {
//            Text("\(player.statePlayer)")
//            PlayerControlsView(audio: audio1)
//            PlayerControlsView(audio: audio2)
//            PlayerControlsView(audio: audio3)
//        }
//        .padding(5)
//    }
//}


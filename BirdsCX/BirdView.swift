import SwiftUI
import Kingfisher
import AVFoundation
import MarkdownUI

struct BirdDetailView: View {
  @State private var audioPlayer: AVPlayer?

  let bird: Bird // Replace `Bird` with your actual model type

  var nativeName: String?

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      // Bird Name
      let combinedString = [
          nativeName ?? "",
          bird.gen ?? "",
          bird.sp ?? "",
          bird.date ?? "",
          bird.time ?? "",
          bird.rec ?? "",
          bird.loc ?? ""
      ].joined(separator: ",")

      VStack(alignment: .leading, spacing: 10) {
        Text(nativeName ?? "")
          .font(.headline)

        Text(bird.en ?? "No bird name")

        HStack {
          Text(bird.gen ?? "")
          Text(bird.sp ?? "")
          Spacer()
        }
        .italic()

        Text(bird.rec ?? "")

        Text(bird.loc ?? "")

        HStack {
          Text(bird.date ?? "")
          Text(bird.time ?? "")
          Spacer()
        }
        .font(.caption)
      }
      .accessibilityElement(children: .combine)
      .accessibilityLabel(combinedString)

      // Large Sono Image
      if let smallSono = bird.sono?.small, let sonoURL = URL(string: "https:" + smallSono) {
        KFImage(sonoURL)
          .resizable()
          .scaledToFit()
          .accessibilityHidden(true)
      }

      if let smallOsci = bird.osci?.small, let osciURL1 = URL(string: "https:" + smallOsci) {
        KFImage(osciURL1)
          .resizable()
          .scaledToFit()
          .accessibilityHidden(true)
      }


      // Full Sono Image
//      if let smallSono = bird.sono?.full, let sonoURL = URL(string: "https:" + smallSono) {
//        KFImage(sonoURL)
//          .resizable()
//          .scaledToFit()
//          .accessibilityHidden(true)
//      }


      if isMP3(filename: bird.fileName ?? "no streaming format") {
        PlayerControlsView(sounds: [bird.file ?? ""], length: bird.length ?? "01:00")
//          .border(Color.blue, width: 1)
//          .background(
//              RoundedRectangle(cornerRadius: 8)
//                  .stroke(Color.blue, lineWidth: 1)
//          )
      } else {
        Text("audio is not streamable")
      }

      if !(bird.rmk?.isEmpty ?? true) {
        ScrollView {
          Markdown() {
            bird.rmk ?? "No remark"
          }
          .frame(maxWidth: .infinity, minHeight: 30)
          .multilineTextAlignment(.leading) // For multiline content
          .padding(8)
          //        .border(Color.gray, width: 1)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.gray, lineWidth: 1)
          )
        }
      }

      Spacer()
    }
    .padding()
  }

  func isMP3(filename: String) -> Bool {
    let pattern = #"^.+\.mp3$"# // Regex pattern to match filenames ending with .mp3
    if let _ = filename.range(of: pattern, options: .regularExpression) {
      return true
    }
    return false
  }
}

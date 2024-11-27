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
          convertToDutchDateAccessible(dateString: bird.date ?? "1900-01-01", timeString: bird.time ?? "00:00") ?? "",
//          bird.date ?? "",
//          bird.time ?? "",
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


        Text(convertToDutchDate(dateString: bird.date ?? "1900-01-01", timeString: bird.time ?? "00:00") ?? "")
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

func convertToDutchDateAccessible(dateString: String, timeString: String) -> String? {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
  dateFormatter.locale = Locale(identifier: "nl_NL") // Set Dutch locale

  // Combine date and time into a single string
  let combinedDateTime = "\(dateString) \(timeString)"

  // Convert to a Date object
  guard let date = dateFormatter.date(from: combinedDateTime) else {
    return nil // Return nil if parsing fails
  }

  // Create another DateFormatter for output
  let outputFormatter = DateFormatter()
  outputFormatter.locale = Locale(identifier: "nl_NL")
  outputFormatter.dateFormat = "EEEE d MMMM yyyy 'om' H 'uur' m" // Dutch format

  //    return outputFormatter.string(from: date).capitalized // Capitalize the first letter

  // Get the formatted string
  let formattedString = outputFormatter.string(from: date)

  // Capitalize only the first character
  return formattedString.prefix(1).uppercased() + formattedString.dropFirst()
}

func convertToDutchDate(dateString: String, timeString: String) -> String? {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
  dateFormatter.locale = Locale(identifier: "nl_NL") // Set Dutch locale

  // Combine date and time into a single string
  let combinedDateTime = "\(dateString) \(timeString)"

  // Convert to a Date object
  guard let date = dateFormatter.date(from: combinedDateTime) else {
    return nil // Return nil if parsing fails
  }

  // Create another DateFormatter for output
  let outputFormatter = DateFormatter()
  outputFormatter.locale = Locale(identifier: "nl_NL")
  outputFormatter.dateFormat = "EEEE d MMMM yyyy HH:mm" // Dutch format

  //    return outputFormatter.string(from: date).capitalized // Capitalize the first letter

  // Get the formatted string
  let formattedString = outputFormatter.string(from: date)

  // Capitalize only the first character
  return formattedString.prefix(1).uppercased() + formattedString.dropFirst()
}

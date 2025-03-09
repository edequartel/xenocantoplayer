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
      ShowView(title: "BirdDetailView")
      //images
      VStack(alignment: .leading, spacing: 10) {
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
      }
      .frame(maxWidth: .infinity)
      .padding()

      .background(
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.gray, lineWidth: 1)
      )

      //url
      OpenURLView(birdURL: bird.url)

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


struct OpenURLView: View {
    var birdURL: String? // The URL source

    var modifiedURL: URL? {
        guard let urlString = birdURL?.replacingOccurrences(of: "//", with: "https://www."),
              let url = URL(string: urlString) else {
            return nil
        }
        return url
    }

    var body: some View {
        VStack {
            if let url = modifiedURL {
                Link("Xeno Canto URL", destination: url)
            } else {
                Text("Invalid URL")
                    .foregroundColor(.red)
            }
        }
    }
}

func modifyURL(from birdURL: String?) -> URL? {
    guard let urlString = birdURL?.replacingOccurrences(of: "//", with: "https://www."),
          let url = URL(string: urlString) else {
        return nil
    }
    return url
}

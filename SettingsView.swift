//
//  SettingsView.swift
//  XC
//
//  Created by Eric de Quartel on 28/11/2024.
//

import SwiftUI
import Accessibility

struct SettingsView: View {
  @Environment(\.locale) private var locale
//  @EnvironmentObject var accessibilityManager: AccessibilityManager

    var body: some View {
      VStack {
      Section(header: Text("App details")) {
        VStack(alignment: .leading) {
          Text(version())
          Text(locale.description)
//          Text(accessibilityManager.isVoiceOverEnabled ? "VoiceOver is ON" : "VoiceOver is OFF")
        }
        .font(.footnote)
        .padding(4)
        .accessibilityElement(children: .combine)
      }
        Button(action: {
          openWebsite(urlString: "https://edequartel.github.io/xenocantoplayer/")
        }) {
          Image(systemName: "gearshape")
        }
        .accessibilityHint("Open website XC")
      }

    }
}

#Preview {
    SettingsView()
}

private func openWebsite(urlString: String) {
  if let url = URL(string: urlString) {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  } else {
    print("Invalid URL")
  }
}

func version() -> String {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String,
          let build = dictionary["CFBundleVersion"] as? String else {
        return "Version information not available"
    }
    return "Version \(version) build \(build)"
}

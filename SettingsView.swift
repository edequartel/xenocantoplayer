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
      Form {
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
          Text("Open website XC")
        }
        .accessibilityHint("Open website XC")
      }
  }
}

#Preview {
  SettingsView()
}


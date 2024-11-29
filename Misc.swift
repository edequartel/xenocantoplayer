//
//  Misc.swift
//  XC
//
//  Created by Eric de Quartel on 28/11/2024.
//

import SwiftUI

func openWebsite(urlString: String) {
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

func stringToIntHash(_ input: String) -> Int {
    return input.hash
}

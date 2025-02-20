//
//  Misc.swift
//  XC
//
//  Created by Eric de Quartel on 28/11/2024.
//

import SwiftUI

let show = false

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

//-----------------------------------------------------------
func rarityColor(value: Int) -> Color {
  switch value {
  case 0:
    return .gray //onbekend
  case 1:
    return .green //algemeen
  case 2:
    return .blue //vrij algemeen
  case 3:
    return .orange //rare
  case 4:
    return .red //very rare
  default:
    return .gray //You can provide a default color or handle other cases as needed
  }
}

enum FilteringRarityOption: String, CaseIterable {
  case all
  case common
  case uncommon
  case rare
  case veryRare

  /// Returns the corresponding integer value for each rarity level
  var intValue: Int? {
    switch self {
    case .all: return 0   // Represents no filtering
    case .common: return 1
    case .uncommon: return 2
    case .rare: return 3
    case .veryRare: return 4
    }
  }

  var localized: LocalizedStringKey {
    LocalizedStringKey(self.rawValue)
  }
}

enum FilterAllOption: String, CaseIterable {
  case all
  case native

  /// Returns the corresponding integer value for each rarity level
  var intValue: Int? {
    switch self {
    case .all: return 0 // Represents no filtering
    case .native: return 1
    }
  }

  // Add more filter options if needed
  var localized: LocalizedStringKey {
    LocalizedStringKey(self.rawValue)
  }
}


//-----------------------------------------------------------
struct FilteringAllOptionsView: View {
  @Binding var currentFilteringAllOption: FilterAllOption

  var body: some View {
    //if showView { Text("FilteringAllOptionsView").font(.customTiny) }
    List(FilterAllOption.allCases, id: \.self) { option in
      Button(action: {
        currentFilteringAllOption = option
      }) {
        HStack {
          Text(option.localized)
          Spacer()
          if currentFilteringAllOption == option {
            Image(systemName: "checkmark")
          }
        }
      }
    }
  }
}

// swiftlint:disable multiple_closures_with_trailing_closure
struct FilterOptionsView: View {
  @Binding var currentFilteringOption: FilteringRarityOption

  var body: some View {
    //if showView { Text("FilterOptionsView").font(.customTiny) }
    List(FilteringRarityOption.allCases, id: \.self) { option in
      Button(action: {
        currentFilteringOption = option
      }) {
        HStack {
          Image(systemName: "circle.fill")
            .foregroundColor(rarityColor(value: option.intValue ?? 0))
          Text(option.localized)
          Spacer()
          if currentFilteringOption == option {
            Image(systemName: "checkmark")
          }
        }
      }
    }
  }
}

struct SortFilterSpeciesView: View {
  @Binding var selectedFilterAllOption: FilterAllOption
  @Binding var selectedRarityOption: FilteringRarityOption

  var body: some View {
    Form {
      // Second Menu for Filtering
      Section("status") {
        FilteringAllOptionsView(currentFilteringAllOption: $selectedFilterAllOption)
      }

      Section("rarity") {
        FilterOptionsView(currentFilteringOption: $selectedRarityOption)
      }
    }
  }
}

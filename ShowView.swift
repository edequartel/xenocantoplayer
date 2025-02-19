//
//  ShowView.swift
//  XC
//
//  Created by Eric de Quartel on 19/02/2025.
//

import SwiftUI

struct ShowView: View {
  var title: String = "Hello, World!"
    var body: some View {
      if show { Text(title).font(.caption) }
    }
}

#Preview {
    ShowView()
}



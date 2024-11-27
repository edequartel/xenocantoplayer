//
//  XCApp.swift
//  XC
//
//  Created by Eric de Quartel on 25/11/2024.
//

import SwiftUI

@main
struct XCApp: App {
  @StateObject var player = Player()
  @StateObject var bookMarksViewModel = BookMarksViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(player)
            .environmentObject(bookMarksViewModel)
        }
    }
}

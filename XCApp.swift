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
  @StateObject var bookMarksViewModel = BookMarksViewModel(fileName: "bookmarks.json")
  @StateObject var cacheMarksViewModel = BookMarksViewModel(fileName: "cachemarks.json")
//  @StateObject private var accessibilityManager = AccessibilityManager()


    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(player)
            .environmentObject(bookMarksViewModel)
            .environmentObject(cacheMarksViewModel)
        }
    }
}

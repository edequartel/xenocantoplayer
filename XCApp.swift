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


    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(player)
            .modelContainer(for: [NumberList.self]) // Attach the SwiftData container
        }
    }
}

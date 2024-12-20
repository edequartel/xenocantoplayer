//
//  BookMarksViewModel.swift
//  Ravens
//
//  Created by Eric de Quartel on 15/05/2024.
//

import Foundation

struct BookMark: Codable, Identifiable {
  var id: UUID = UUID()  // Unique identifier for SwiftUI List operations
  //    var name: String?
  //    var group: String?
  var speciesID: Int //bookmarkID
}


import SwiftUI

class BookMarksViewModel: ObservableObject {
  @Published var records: [BookMark] = []

  let fileManager = FileManager.default
  let filePath: URL

  init() {
      // Get the documents directory path
      let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
      filePath = documentsPath.appendingPathComponent("bookmarks.json")

      // Check if the file exists
      if fileManager.fileExists(atPath: filePath.path) {
          print("File exists at path: \(filePath.path)")
          loadRecords()
      } else {
          print("File does not exist at path: \(filePath.path). Creating file...")
          let initialContent = "{}" // Default empty JSON content

          // Attempt to create the file
          do {
              try initialContent.write(to: filePath, atomically: true, encoding: .utf8)
              print("File created successfully at path: \(filePath.path)")
          } catch {
              print("Failed to create file. Error: \(error.localizedDescription)")
          }
      }
  }
  
  func loadRecords() {
    do {
      let data = try Data(contentsOf: filePath)
      records = try JSONDecoder().decode([BookMark].self, from: data)
    } catch {
      print("BookMarksViewModel Error loading data: \(error)")
    }
  }
  
  func saveRecords() {
    do {
      let data = try JSONEncoder().encode(records)
      try data.write(to: filePath, options: .atomicWrite)
    } catch {
      print("BookMarksViewModel Error saving data: \(error)")
    }
  }
  
  func isSpeciesIDInRecords(speciesID: Int) -> Bool {
    return records.contains(where: { $0.speciesID == speciesID })
  }
  
  func appendRecord(speciesID: Int) {
    print("appendRecord(\(speciesID))")
    guard !records.contains(where: { $0.speciesID == speciesID }) else {
      return
    }
    let newRecord = BookMark(speciesID: speciesID)
    records.append(newRecord)
    saveRecords()
  }
  
  
  func removeRecord(speciesID: Int) {
    print("removeRecord(\(speciesID))")
    if let index = records.firstIndex(where: { $0.speciesID == speciesID }) {
      records.remove(at: index)
      saveRecords()
    } else {
      print("BookMarksViewModel Record with speciesID \(speciesID) does not exist.")
    }
  }
}

import SwiftUI

struct BookMarksView: View {
  @EnvironmentObject private var viewModel: BookMarksViewModel
  
  var body: some View {
    VStack {
      List {
        ForEach(viewModel.records) { record in
          HStack{
            Text("(\(record.speciesID))")
            Spacer()
          }
        }
      }
    }
  }
}

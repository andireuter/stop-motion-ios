//
//  StopMotionApp.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import SwiftUI
import SwiftData

@main
struct StopMotionApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      Library.self,
      Photo.self,
    ])
    
    let cloudConfig = ModelConfiguration(
      "Cloud",
      schema: schema,
      cloudKitDatabase: .private("iCloud.com.andireuter.StopMotionForKids")
    )
    
    do {
      return (try ModelContainer(for: Schema([Photo.self]), configurations: [cloudConfig]))
    } catch {
      fatalError("Could not create CloudKit private database: \(error)")
    }
  }()

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(sharedModelContainer)
  }
}

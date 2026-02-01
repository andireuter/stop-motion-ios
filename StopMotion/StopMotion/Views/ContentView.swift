//
//  ContentView.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.navItem) var navItemStore: NavItemStore
  @State private var activeLibrary: Library?

  var body: some View {
    VStack(spacing: 24) {
      if navItemStore.navItem == .stopMotionPlayer {
        StopMotionPlayerView(
          photos: activeLibrary?.sortedPhotos ?? [],
          onClose: { navItemStore.navItem = .photoCamera }
        )
      } else if navItemStore.navItem == .photoCamera, let library = activeLibrary {
        PhotoCameraView(
          library: library,
          onClose: { navItemStore.navItem = .library }
        )
      } else {
        LibraryView(onOpen: { library in
          self.activeLibrary = library
          navItemStore.navItem = .photoCamera
        })
      }
    }
    .frame(maxHeight: .infinity, alignment: .bottom)
    .statusBarHidden(true)
    .environment(\.navItem, navItemStore)
  }
}

#Preview {
  ContentView()
}

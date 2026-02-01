//
//  PhotoRibbonView.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import SwiftUI
import SwiftData

struct PhotoRibbonView: View {
  let library: Library
  
  @Environment(\.navItem) var navItemStore: NavItemStore
  @Environment(\.modelContext) private var modelContext
  @State private var showDeleteConfirmation = false
  
  var body: some View {
    VStack(spacing: 24) {
      PhotoRibbonToolbar(
        onPlay: { play in
          if play {
            navItemStore.navItem = .stopMotionPlayer
          }
        },
        onVanish: { showDeleteConfirmation = true }
      )
      
      ScrollView(.horizontal) {
        LazyHStack {
          ForEach(library.sortedPhotos ?? []) { photo in
            if let data = photo.imageData, let uiImage = UIImage(data: data) {
              Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            }
          }
        }
      }
    }
//    .confirmationDialog(
//      "Wirklich alle Bilder löschen?",
//      isPresented: $showDeleteConfirmation,
//      titleVisibility: .visible
//    ) {
//      Button("Unwiderruflich löschen", role: .destructive) {
//        deletePhotos()
//      }
//      Button("Cancel", role: .cancel) { }
//    } message: {
//      Text("Du löscht alle deine aufgenommenen Bilder. Dies kann nicht rückgängig gemacht werden.")
//    }
  }
//  
//  private func deletePhotos() {
//    withAnimation {
//      for index in photos.indices {
//        modelContext.delete(photos[index])
//      }
//      try? modelContext.save()
//    }
//  }
}

#Preview {
  PhotoRibbonView(library: .init(name: "Unknown"))
}

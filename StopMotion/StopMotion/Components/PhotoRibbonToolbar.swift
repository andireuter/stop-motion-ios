//
//  PhotoRibbonToolbar.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import SwiftUI
import AVFoundation
import SwiftData

struct PhotoRibbonToolbar: View {
  var onPlay: (_ play: Bool) -> Void
  var onVanish: () -> Void
  
  @State private var isSharePresented = false
  @State private var shareURL: URL? = nil

  var body: some View {
    HStack(spacing: 48) {
      Spacer()
      PlayButton(onPlay: onPlay)
//      Button(action: {
//        onVanish()
//      }) {
//        Image(systemName: "trash.fill")
//          .imageScale(.large)
//      }
      Spacer()
    }
  }
}

#Preview {
  PhotoRibbonToolbar(
    onPlay: { _ in print("Play tapped") },
    onVanish: { print("Vanish tapped") }
  )
}

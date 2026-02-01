//
//  CloseButton.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import SwiftUI

struct CloseButton: View {
  var size: CGFloat
  var onClose: () -> Void

  public var body: some View {
    Button(action: onClose) {
      Image(systemName: "xmark")
        .resizable()
        .scaledToFit()
        .shadow(color: .black, radius: 2)
        .frame(width: size, height: size)
        .foregroundStyle(.white)
        .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  CloseButton(size: 24, onClose: { print("Close tapped") })
}

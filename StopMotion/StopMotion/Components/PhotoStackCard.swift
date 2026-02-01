//
//  PhotoStackCard.swift
//  StopMotion
//
//  Created by Andreas Reuter on 25.01.26.
//

import SwiftUI

struct PhotoStackCard: View {
  let photos: [Photo]
  
  private let maxCount = 3
  private let offsets: [CGSize] = [
    CGSize(width: 0, height: 0),
    CGSize(width: 10, height: 10),
    CGSize(width: 20, height: 20)
  ]
  private let rotations: [Double] = [0, -6, 6]
  
  var body: some View {
    ZStack {
      ForEach(Array(photos.prefix(maxCount).enumerated()), id: \.offset) { index, photo in
        PhotoThumbnail(photo: photo)
          .frame(width: 120, height: 150)
          .cornerRadius(10)
          .shadow(radius: 3, x: 1, y: 1)
          .rotationEffect(.degrees(rotations[index]))
          .offset(offsets[index])
      }
    }
    .frame(width: 140, height: 170)
  }
}

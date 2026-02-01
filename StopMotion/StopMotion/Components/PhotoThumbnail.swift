//
//  PhotoThumbnail.swift
//  StopMotion
//
//  Created by Andreas Reuter on 25.01.26.
//

import SwiftUI

struct PhotoThumbnail: View {
  let photo: Photo
  
  var body: some View {
    if let data = photo.imageData, let uiImage = UIImage(data: data) {
      Image(uiImage: uiImage)
        .resizable()
        .scaledToFill()
        .clipped()
    }
  }
}

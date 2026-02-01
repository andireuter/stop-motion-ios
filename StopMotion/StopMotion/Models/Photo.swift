//
//  Photo.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Photo {
  @Attribute(.externalStorage)
  var imageData: Data?
  
  var changedAt: Date?
  var library: Library?

  init(imageData: Data, changedAt: Date = Date(), library: Library) {
    self.imageData = imageData
    self.changedAt = changedAt
    self.library = library
  }
}

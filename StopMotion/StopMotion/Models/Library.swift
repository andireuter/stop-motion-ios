//
//  Library.swift
//  StopMotion
//
//  Created by Assistant on 25.01.26
//

import Foundation
import SwiftData

@Model
final class Library {
  var name: String = "Unknown"
  
  @Relationship(deleteRule: .cascade, inverse: \Photo.library)
  var photos: [Photo]?
  
  var sortedPhotos: [Photo]? {
    (photos ?? []).sorted { (lhs: Photo, rhs: Photo) in
      lhs.changedAt! < rhs.changedAt! }
  }
  
  var changedAt: Date?

  init(name: String, changedAt: Date = Date()) {
    self.name = name
    self.photos = [Photo]()
    self.changedAt = changedAt
  }

  func addPhoto(_ photo: Photo) {
    photos?.append(photo)
    changedAt = Date()
  }

  func removePhoto(_ photo: Photo) {
    if let index = photos?.firstIndex(where: { $0 === photo }) {
      photos?.remove(at: index)
      changedAt = Date()
    }
  }
}


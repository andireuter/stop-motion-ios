//
//  Photo+defaultSort.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import Foundation

extension Photo {
  static let defaultSort: [SortDescriptor<Photo>] = [
    SortDescriptor(\.changedAt, order: .forward)
  ]
}

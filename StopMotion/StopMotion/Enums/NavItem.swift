//
//  NavItem.swift
//  StopMotion
//
//  Created by Andreas Reuter on 25.01.26.
//

import SwiftUI

enum NavItem {
  case library
  case photoCamera
  case stopMotionPlayer
}

private struct NavItemKey: EnvironmentKey {
  static let defaultValue: NavItemStore = .init(navItem: .library)
}

extension EnvironmentValues {
  var navItem: NavItemStore {
    get { self[NavItemKey.self] }
    set { self[NavItemKey.self] = newValue }
  }
}

@Observable
final class NavItemStore {
  var navItem: NavItem
  
  init(navItem: NavItem) {
    self.navItem = navItem
  }
}

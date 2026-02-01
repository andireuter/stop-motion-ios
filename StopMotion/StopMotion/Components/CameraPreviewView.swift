//
//  CameraPreview.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import SwiftUI
import AVFoundation

class CameraPreviewView: UIView {
  let preview: CALayer
  
  init(preview: CALayer) {
    self.preview = preview
    super.init(frame: .zero)
    layer.addSublayer(preview)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    preview.frame = bounds
  }
}

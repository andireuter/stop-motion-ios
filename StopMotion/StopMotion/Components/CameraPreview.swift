//
//  CameraPreview.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
  private let preview: CALayer
  
  init(preview: CALayer) {
    self.preview = preview
  }
  
  func makeUIView(context: Context) -> CameraPreviewView {
    CameraPreviewView(preview: preview)
  }
  
  func updateUIView(_ uiView: CameraPreviewView, context: Context) {
    
  }
}

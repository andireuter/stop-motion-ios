//
//  PhotoCameraView.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import SwiftUI
import Combine
import AVFoundation
import SwiftData

struct PhotoCameraView: View {
  let library: Library
  let onClose: () -> Void
  
  @Environment(\.modelContext) private var modelContext
  @StateObject private var camera = PhotoCameraViewModel()
  
  var body: some View {
    VStack {
      ZStack {
        CameraPreview(preview: {
          let layer = camera.previewLayer
          layer.videoGravity = .resizeAspectFill
          
          if layer.session == nil {
            layer.session = camera.cameraSession
          }
          
          return (layer)
        }())
        
        HStack {
          CloseButton(size: 24) {
            onClose()
          }
          .padding(48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        
        HStack {
          Button {
            camera.capturePhoto()
          } label: {
            ZStack {
              Circle()
                .fill(.white.opacity(0.9))
                .frame(width: 72, height: 72)
              Circle()
                .stroke(.white, lineWidth: 3)
                .frame(width: 82, height: 82)
            }
          }
        }
        .padding(.bottom, 24)
        .frame(maxHeight: .infinity, alignment: .bottom)
      }
      
      PhotoRibbonView(library: library)
        .frame(height: 144)
    }
    .ignoresSafeArea(edges: .all)
    .onAppear { camera.requestAndStart() }
    .onDisappear { camera.stop() }
    .onReceive(camera.$lastPhoto) { lastPhoto in
      guard let lastPhoto = lastPhoto else {
        return
      }
      
      addPhoto(image: lastPhoto)
    }
  }
  
  private func addPhoto(image: UIImage) {
    withAnimation {
      if let imageData = image.jpegData(compressionQuality: 0.9) {
        let newPhoto = Photo(
          imageData: imageData,
          library: self.library
        )
        modelContext.insert(newPhoto)
        try? modelContext.save()
      }
    }
  }
}

#Preview {
  PhotoCameraView(
    library: .init(name: "Unknown"),
    onClose: { print("Close tapped") }
  )
}

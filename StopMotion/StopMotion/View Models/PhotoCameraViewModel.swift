//
//  PhotoCameraViewModel.swift
//  StopMotion
//
//  Created by Andreas Reuter on 24.01.26.
//

import AVFoundation
import SwiftUI
import Combine

@MainActor
final class PhotoCameraViewModel: NSObject, ObservableObject {
  @Published var lastPhoto: UIImage?
  
  let cameraSession = AVCaptureSession()
  let previewLayer = AVCaptureVideoPreviewLayer()
  
  private var isRunning = false
  private let videoRotationAngle: CGFloat = 90
  private let sessionQueue = DispatchQueue(label: "camera.session.queue")
  private let cameraPhotoOutput = AVCapturePhotoOutput()
  private var cameraInput: AVCaptureDeviceInput?

  private func updatePreviewOrientation() {
    guard let connection = self.previewLayer.connection, connection.isVideoOrientationSupported else { return }
    connection.videoOrientation = .landscapeRight
  }

  override init() {
    super.init()
    configureCamera()
  }

  private func configureCamera() {
    self.cameraSession.beginConfiguration()
    self.cameraSession.sessionPreset = .hd1920x1080
    // Configure output orientation; preview orientation will be set when the layer has a connection.
    self.previewLayer.videoGravity = .resizeAspectFill
    if let photoConnection = self.cameraPhotoOutput.connection(with: .video), photoConnection.isVideoOrientationSupported {
      photoConnection.videoOrientation = .landscapeRight
    }

    guard
      let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
      let cameraInput = try? AVCaptureDeviceInput(device: cameraDevice),
      self.cameraSession.canAddInput(cameraInput)
    else {
      self.cameraSession.commitConfiguration()
      return
    }
    
    self.cameraSession.addInput(cameraInput)
    self.cameraInput = cameraInput

    guard self.cameraSession.canAddOutput(self.cameraPhotoOutput) else {
      self.cameraSession.commitConfiguration()
      return
    }

    self.cameraSession.addOutput(self.cameraPhotoOutput)

    if let cameraDevice = self.cameraInput?.device {
      let supported = cameraDevice.activeFormat.supportedMaxPhotoDimensions
      
      // Prefer 1920x1080 if available, otherwise choose the largest by pixel count.
      let preferred =
        supported.first(where: { $0.width == 1920 && $0.height == 1080 }) ??
        supported.max(by: { ($0.width * $0.height) < ($1.width * $1.height) })
      
      if let preferred {
        self.cameraPhotoOutput.maxPhotoDimensions = preferred
      }
    }

    self.cameraSession.commitConfiguration()
  }

  func requestAndStart() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      Task { @MainActor in
        self.start()
      }
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          Task { @MainActor in
            self.start()
          }
        }
      }
    default:
      break
    }
  }

  func start() {
    if self.cameraSession.isRunning {
      return
    }

    sessionQueue.async { [weak self] in
      guard let self = self else { return }
      self.cameraSession.startRunning()

      DispatchQueue.main.async { [weak self] in
        self?.updatePreviewOrientation()
        self?.isRunning = true
      }
    }
  }

  func stop() {
    guard self.cameraSession.isRunning else {
      return
    }

    self.cameraSession.stopRunning()
    self.isRunning = false
  }

  func capturePhoto() {
    let settings = AVCapturePhotoSettings()
    
    if let photoConnection = self.cameraPhotoOutput.connection(with: .video), photoConnection.isVideoOrientationSupported {
      photoConnection.videoOrientation = .landscapeRight
    }
    
    if let cameraDevice = self.cameraInput?.device {
      let supported = cameraDevice.activeFormat.supportedMaxPhotoDimensions
      
      // Prefer 1920x1080 if available, otherwise choose the largest by pixel count.
      let preferred =
        supported.first(where: { $0.width == 1920 && $0.height == 1080 }) ??
        supported.max(by: { ($0.width * $0.height) < ($1.width * $1.height) })
      
      if let preferred {
        settings.maxPhotoDimensions = preferred
      }
    }
    
    self.cameraPhotoOutput.capturePhoto(with: settings, delegate: self)
  }
}

extension PhotoCameraViewModel: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard error == nil,
      let data = photo.fileDataRepresentation(),
      let image = UIImage(data: data) else { return }

    self.lastPhoto = image
  }
}


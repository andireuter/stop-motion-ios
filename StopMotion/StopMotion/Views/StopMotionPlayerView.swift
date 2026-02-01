import SwiftUI
import SwiftData

struct StopMotionPlayerView: View {
  let photos: [Photo]
  @State private var currentIndex: Int = 0
  @State private var playbackTimer: Timer? = nil
  
  let framesPerSecond: Double = 2.0
  let onClose: () -> Void
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      Group {
        if photos.indices.contains(currentIndex),
           let data = photos[currentIndex].imageData,
           let uiImage = UIImage(data: data) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
        } else {
          Text("No photos to play")
            .foregroundStyle(.secondary)
        }
      }

      CloseButton(size: 24) {
        stop()
        onClose()
      }
      .padding(48)
    }
    .onAppear { play() }
    .onDisappear { stop() }
  }
  
  private func play() {
    currentIndex = 0
    playbackTimer?.invalidate()
    guard !photos.isEmpty else { return }
    
    let interval = 1.0 / max(1.0, framesPerSecond)
    playbackTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
      if currentIndex + 1 < photos.count {
        currentIndex += 1
      } else {
        stop()
      }
    }
  }
  
  private func stop() {
    playbackTimer?.invalidate()
    playbackTimer = nil
  }
}

#Preview {
  StopMotionPlayerView(photos: [], onClose: { print("Close tapped") })
}

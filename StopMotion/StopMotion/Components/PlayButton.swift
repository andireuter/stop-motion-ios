import SwiftUI

struct PlayButton: View {
  var onPlay: (_ play: Bool) -> Void
  @State private var isPlaying: Bool = false

  var body: some View {
    Button(action: {
      isPlaying.toggle()
      onPlay(isPlaying)
    }) {
      Image(systemName: isPlaying ? "pause.fill" : "play.fill")
        .imageScale(.large)
    }
  }
}

#Preview {
  PlayButton(onPlay: { _ in print("Play tapped") })
}

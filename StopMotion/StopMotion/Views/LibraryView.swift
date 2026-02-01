import SwiftUI
import SwiftData

struct LibraryView: View {
  let onOpen: (_ library: Library) -> Void
  
  @Environment(\.navItem) private var navItem
  @Environment(\.modelContext) private var modelContext
  @Query private var libraries: [Library]
  
  private let columns = [
    GridItem(.adaptive(minimum: 150))
  ]
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 16) {
        Button {
          let newLibrary = createLibrary()
          onOpen(newLibrary)
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 12)
              .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
              .foregroundColor(.primary.opacity(0.6))
              .frame(height: 150)
            Image(systemName: "plus")
              .font(.system(size: 40, weight: .semibold))
              .foregroundColor(.primary.opacity(0.6))
          }
        }
        .buttonStyle(.plain)
        
        ForEach(libraries, id: \.self) { library in
          let photos = library.sortedPhotos ?? []
          if !photos.isEmpty {
            Button {
              onOpen(library)
            } label: {
              PhotoStackCard(photos: photos)
            }
            .buttonStyle(.plain)
          }
        }
      }
      .padding(24)
    }
  }
  
  private func createLibrary() -> Library {
    let newLibrary = Library(name: "Unknown")
    modelContext.insert(newLibrary)
    try? modelContext.save()
    return (newLibrary)
  }
}

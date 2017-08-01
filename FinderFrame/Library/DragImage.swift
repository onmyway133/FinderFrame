import Cocoa

class DragImage: DragItem {
  let name: String
  let image: NSImage

  init?(url: URL) {
    guard let image = NSImage(contentsOf: url) else {
      return nil
    }

    self.image = image
    self.name = url.deletingPathExtension().lastPathComponent
  }
}

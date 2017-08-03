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

  func save(window: NSWindow, completion: @escaping () -> Void) {
    defer {
      completion()
    }

    guard let image = Utils.capture(window: window),
      let data = image.toData() else {
      return
    }

    let url = Utils.outputUrl.appendingPathExtension("png")

    do {
      try data.write(to: url)
      Utils.showNotification(url: url)
    } catch {
      print(error)
    }
  }
}

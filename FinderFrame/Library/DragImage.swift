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

  func save(window: NSWindow) {
    guard let cgImage = CGWindowListCreateImage(
      CGRect.null,
      CGWindowListOption.optionIncludingWindow,
      CGWindowID(window.windowNumber),
      CGWindowImageOption.bestResolution) else {
        return
    }


    let image = NSImage(cgImage: cgImage, size: window.frame.size)
    write(image: image)
  }

  func write(image: NSImage) {
    guard let tiffData = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let imageData = bitmap.representation(using: .PNG, properties: [:]) else {
        return
    }

    let url = URL(fileURLWithPath: NSHomeDirectory().appending("/Downloads"))
      .appendingPathComponent("FinderFrame-\(Utils.appName)-\(Utils.format(date: Date()))")
      .appendingPathExtension("png")

    do {
      try imageData.write(to: url)
      Utils.showNotification(url: url, title: Utils.appName)
    } catch {
      print(error)
    }
  }
}

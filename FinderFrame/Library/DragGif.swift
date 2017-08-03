import Cocoa
import GifMagic

class DragGif: DragItem {
  let name: String
  let image: NSImage

  let result: Decoder.Result

  init?(url: URL) {
    guard url.lastPathComponent.hasSuffix("gif"),
      let result = Decoder().decode(fileUrl: url),
      let image = NSImage(contentsOf: url) else {
      return nil
    }

    self.name = url.deletingPathExtension().lastPathComponent
    self.result = result
    self.image = image
  }

  func save(window: NSWindow, completion: @escaping () -> Void) {
    // Gif does not support transparent shadow
    window.hasShadow = false
    window.contentView?.isHidden = true

    // Run for next run loop
    DispatchQueue.main.async {
      defer {
        window.hasShadow = true
        window.contentView?.isHidden = false
      }

      guard let windowImage = Utils.capture(window: window) else {
        completion()
        return
      }

      DispatchQueue.global().async {
        self.save(windowImage: windowImage, completion: completion)
      }
    }
  }

  // MARK: - Helper

  fileprivate func save(windowImage: NSImage,
                        completion: @escaping () -> Void) {
    defer {
      completion()
    }

    let images = self.result.images.flatMap({ image in
      return Utils.draw(image: image,
                        onto: windowImage)
    })

    guard let url =
      Encoder().encode(images: images,
                      frameDuration: self.result.gifInfo.frameDuration,
                      fileName: Utils.outputFileName) else {
      return
    }

    Utils.showNotification(url: url)
  }
}

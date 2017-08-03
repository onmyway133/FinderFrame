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

  func afterDrag(window: NSWindow) {
    window.hasShadow = false
  }

  func save(window: NSWindow) {
    guard let windowImage = Utils.capture(window: window) else {
      return
    }

    let images = result.images.flatMap({ image in
      return Utils.draw(image: image, onto: windowImage)
    })

    guard let url = Encoder().encode(images: images,
                                     frameDuration: result.gifInfo.frameDuration) else {
      return
    }

    Utils.showNotification(url: url)
  }
}

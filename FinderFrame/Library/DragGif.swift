import Cocoa
import GifMagic

class DragGif: DragItem {
  let name: String
  let image: NSImage

  let handler = Handler(encoder: Encoder(), decoder: Decoder())
  let result: Decoder.Result

  init?(url: URL) {
    guard url.lastPathComponent == "gif",
      let result = handler.decoder.decode(fileUrl: url),
      let image = result.images.first else {
      return nil
    }

    self.name = url.deletingPathExtension().lastPathComponent
    self.result = result
    self.image = image
  }

  func save(window: NSWindow) {
    
  }
}

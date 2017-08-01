import Cocoa
import GifMagic

class DragGif: DragItem {
  let name: String
  let url: URL
  let handler = Handler(encoder: Encoder(), decoder: Decoder())

  init?(url: URL) {
    guard url.lastPathComponent == "gif" else {
      return nil
    }

    self.url = url
    self.name = url.deletingPathExtension().lastPathComponent
  }
}

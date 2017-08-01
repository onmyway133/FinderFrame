import Cocoa

extension NSImage {
  func toData() -> Data? {
    guard let tiffData = tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let imageData = bitmap.representation(using: .PNG, properties: [:]) else {
        return nil
    }

    return imageData
  }
}

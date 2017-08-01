import Cocoa

extension NSImage {
  func toBitmap() -> NSBitmapImageRep? {
    guard let tiffData = tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData) else {
        return nil
    }

    return bitmap
  }

  func toData() -> Data? {
    guard let bitmap = toBitmap(),
      let imageData = bitmap.representation(using: .PNG, properties: [:]) else {
        return nil
    }

    return imageData
  }
}

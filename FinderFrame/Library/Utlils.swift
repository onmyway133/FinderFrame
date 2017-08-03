import Cocoa

class Utils {
  static var outputFileName: String {
    return "\(Utils.appName)-\(UUID().uuidString)"
  }

  static var outputUrl: URL {
    return downloadFolderUrl.appendingPathComponent(outputFileName)
  }

  static func resize(window: NSWindow, image: NSImage) {
    guard let screen = window.screen else {
      assertionFailure()
      return
    }

    let minWidth: CGFloat = 300
    let maxWidth = screen.frame.size.width * 0.8

    let ratio: CGFloat = image.size.height / image.size.width
    let finalWidth: CGFloat = image.size.width.sanitize(min: minWidth, max: maxWidth)
    let finalSize = CGSize(width: finalWidth,
                           height: finalWidth * ratio + window.titleBarHeight)
    let frame = NSRect(origin: window.frame.origin, size: finalSize)

    window.setFrame(frame, display: true)
  }

  static func showNotification(url: URL) {
    let notification = NSUserNotification()
    notification.title = Utils.appName
    notification.informativeText = url.absoluteString
    notification.hasActionButton = true
    notification.actionButtonTitle = "Open"

    NSUserNotificationCenter.default.deliver(notification)
  }

  static func capture(window: NSWindow) -> NSImage? {
    guard let cgImage = CGWindowListCreateImage(
      CGRect.null,
      CGWindowListOption.optionIncludingWindow,
      CGWindowID(window.windowNumber),
      CGWindowImageOption.bestResolution) else {
        return nil
    }

    return NSImage(cgImage: cgImage, size: window.frame.size)
  }

  static func draw(image: NSImage,
                   onto backgroundImage: NSImage) -> NSImage? {
    guard let canvas = backgroundImage.copy() as? NSImage else {
      return nil
    }

    NSGraphicsContext.saveGraphicsState()
    canvas.lockFocus()
    NSGraphicsContext.current()?.imageInterpolation = NSImageInterpolation.high
    image.draw(at: .zero,
               from: .zero,
               operation: .sourceOver,
               fraction: 1.0)

    canvas.unlockFocus()
    NSGraphicsContext.restoreGraphicsState()

    return canvas
  }

  // MARK: - Helper
  fileprivate static var downloadFolderUrl: URL {
    return URL(fileURLWithPath: NSHomeDirectory().appending("/Downloads"))
  }

  fileprivate static var appName: String {
    guard let name = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
      fatalError()
    }

    return name
  }
}

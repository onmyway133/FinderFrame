import Cocoa

class Utils {
  static var appName: String {
    guard let name = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
      fatalError()
    }

    return name
  }

  static var outputUrl: URL {
    return downloadFolderUrl
      .appendingPathComponent("FinderFrame-\(Utils.appName)-\(Utils.format(date: Date()))")
  }

  static func resize(window: NSWindow, image: NSImage) {
    let minWidth: CGFloat = 300
    let ratio: CGFloat = image.size.height / image.size.width
    let finalSize: CGSize

    if image.size.width > minWidth {
      finalSize = image.size
    } else {
      finalSize = CGSize(width: minWidth, height: minWidth * ratio)
    }

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

  // MARK: - Helper
  fileprivate static func format(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy-HH:mm:ss"

    return formatter.string(from: date)
  }

  fileprivate static var downloadFolderUrl: URL {
    return URL(fileURLWithPath: NSHomeDirectory().appending("/Downloads"))
  }
}

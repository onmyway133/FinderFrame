import Cocoa

class ViewController: NSViewController, DestinationViewDelegate {

  let destinationView = DestinationView()
  var saveMenuItem: NSMenuItem!
  var fileName = "FinderFrame"

  override func viewDidLoad() {
    super.viewDidLoad()

    destinationView.delegate = self
    view.addSubview(destinationView)

    saveMenuItem = (NSApplication.shared().delegate as! AppDelegate).saveMenuItem
    saveMenuItem?.target = self
    saveMenuItem.action = #selector(handleSaveCommand)
    saveMenuItem.isEnabled = false
  }

  override func viewDidLayout() {
    super.viewDidLayout()

    destinationView.frame = view.bounds
  }

  // MARK: - DestinationViewDelegate

  func destinationView(_ view: DestinationView, didDrag item: DragItem) {
    guard let window = view.window else {
      return
    }

    fileName = item.name
    saveMenuItem.isEnabled = true
    resize(window: window, image: item.image)
  }

  func resize(window: NSWindow, image: NSImage) {
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

  func handleSaveCommand() {
    guard let window = view.window else {
      return
    }

    guard let cgImage = CGWindowListCreateImage(
      CGRect.null,
      CGWindowListOption.optionIncludingWindow,
      CGWindowID(window.windowNumber),
      CGWindowImageOption.bestResolution) else {
      return
    }


    let image = NSImage(cgImage: cgImage, size: window.frame.size)
    save(image: image)
  }

  func save(image: NSImage) {
    guard let tiffData = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let imageData = bitmap.representation(using: .PNG, properties: [:]) else {
      return
    }

    let url = URL(fileURLWithPath: NSHomeDirectory().appending("/Downloads"))
      .appendingPathComponent("FinderFrame-\(fileName)-\(formattedDate())")
      .appendingPathExtension("png")

    do {
      try imageData.write(to: url)
      showNotification(url: url)
    } catch {
      print(error)
    }
  }

  func showNotification(url: URL) {
    let notification = NSUserNotification()
    notification.title = fileName
    notification.informativeText = url.absoluteString
    notification.hasActionButton = true
    notification.actionButtonTitle = "Open"

    NSUserNotificationCenter.default.deliver(notification)
  }

  func formattedDate() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy-HH:mm:ss"

    return formatter.string(from: Date())
  }
}


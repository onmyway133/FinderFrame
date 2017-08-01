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
    Utils.resize(window: window, image: item.image)
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
      .appendingPathComponent("FinderFrame-\(fileName)-\(Utils.format(date: Date()))")
      .appendingPathExtension("png")

    do {
      try imageData.write(to: url)
      Utils.showNotification(url: url, title: fileName)
    } catch {
      print(error)
    }
  }
}


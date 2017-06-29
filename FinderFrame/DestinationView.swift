import Cocoa

protocol DestinationViewDelegate {
  func processImageURLs(_ urls: [URL], center: NSPoint)
  func processImage(_ image: NSImage, center: NSPoint)
  func processAction(_ action: String, center: NSPoint)
}

class DestinationView: NSView {

  let imageView = NSImageView()
  var isDragging = false

  let options: [String: Any] = [
    NSPasteboardURLReadingContentsConformToTypesKey: NSImage.imageTypes()
  ]

  override func viewDidMoveToSuperview() {
    super.viewDidMoveToSuperview()

    let types = [NSURLPboardType]
    register(forDraggedTypes: types)

//    addSubview(imageView)
  }

  override func resizeSubviews(withOldSize oldSize: NSSize) {
    super.resizeSubviews(withOldSize: oldSize)

    imageView.frame = bounds
  }

  // MARK: - NSDraggingDestination

  override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    let pasteBoard = sender.draggingPasteboard()

    let canRead = pasteBoard.canReadObject(forClasses: [NSURL.self], options: options)
    isDragging = canRead

    return isDragging ? .copy : NSDragOperation()
  }

  override func draggingExited(_ sender: NSDraggingInfo?) {
    isDragging = false
  }

  override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    let pasteBoard = sender.draggingPasteboard()

    guard let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options: options) as? [URL],
      let url = urls.first else {
      return false
    }

    imageView.image = NSImage(contentsOf: url)

    return true
  }
}


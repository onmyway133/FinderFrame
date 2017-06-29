import Cocoa

protocol DestinationViewDelegate: class {
  func destinationView(_ view: DestinationView, didGetImage image: NSImage, name: String)
}

class DestinationView: NSView {

  weak var delegate: DestinationViewDelegate?

  private let imageView = NSImageView()
  private var isDragging = false

  private let options: [String: Any] = [
    NSPasteboardURLReadingContentsConformToTypesKey: NSImage.imageTypes()
  ]

  override func viewDidMoveToSuperview() {
    super.viewDidMoveToSuperview()

    let types = [NSURLPboardType]
    register(forDraggedTypes: types)

    imageView.imageScaling = .scaleProportionallyUpOrDown
    imageView.unregisterDraggedTypes()
    addSubview(imageView)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
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
      let url = urls.first,
      let image = NSImage(contentsOf: url) else {
      return false
    }

    imageView.image = image
    let name = url.deletingPathExtension().lastPathComponent
    window?.title = name
    delegate?.destinationView(self, didGetImage: image, name: name)

    return true
  }
}


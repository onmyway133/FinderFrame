import Cocoa

protocol DestinationViewDelegate: class {
  func destinationView(_ view: DestinationView, didGetImage image: NSImage, name: String)
}

class DestinationView: NSView {

  weak var delegate: DestinationViewDelegate?

  private let imageView = NSImageView()
  private var isDragging = false {
    didSet {
      frameView.alphaValue = isDragging ? 1 : 0
    }
  }

  private var frameView = NSBox()

  private let options: [String: Any] = [
    NSPasteboardURLReadingContentsConformToTypesKey: NSImage.imageTypes()
  ]

  override func viewDidMoveToSuperview() {
    super.viewDidMoveToSuperview()

    let types = [NSURLPboardType]
    register(forDraggedTypes: types)

    // ImageView
    addSubview(imageView)
    imageView.imageScaling = .scaleProportionallyUpOrDown
    imageView.unregisterDraggedTypes()
    imageView.pinEdges()

    // FrameView
    addSubview(frameView)
    frameView.title = ""
    frameView.unregisterDraggedTypes()
    frameView.alphaValue = 1
    frameView.borderColor = NSColor.red
    frameView.borderWidth = 4
    frameView.pinEdges()
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

extension NSView {
  func pinEdges() {
    let superview = self.superview!

    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
    leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
    bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
  }
}


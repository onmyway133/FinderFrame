import Cocoa
import Anchors

protocol DestinationViewDelegate: class {
  func destinationView(_ view: DestinationView, didDrag item: DragItem)
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
    activate(
      imageView.anchor.edges
    )

    // FrameView
    addSubview(frameView)
    frameView.title = ""
    frameView.boxType = .custom
    frameView.unregisterDraggedTypes()
    frameView.alphaValue = 0
    frameView.borderType = .lineBorder
    frameView.borderColor = NSColor.blue.withAlphaComponent(0.3)
    frameView.borderWidth = 4

    activate(
      frameView.anchor.edges
    )
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

  override func draggingEnded(_ sender: NSDraggingInfo?) {
    isDragging = false
  }

  override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    let pasteBoard = sender.draggingPasteboard()

    guard let urls = pasteBoard.readObjects(forClasses: [NSURL.self],
                                            options: options) as? [URL],
      let url = urls.first else {
      return false
    }

    guard let item: DragItem = DragImage(url: url) ?? DragGif(url: url) else {
      return false
    }

    imageView.image = item.image
    window?.title = item.name
    delegate?.destinationView(self, didDrag: item)

    return true
  }
}

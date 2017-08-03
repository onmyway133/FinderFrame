import Cocoa
import Anchors

class ViewController: NSViewController, DestinationViewDelegate {

  let destinationView = DestinationView()
  let loadingIndicator = LoadingIndicator()
  var saveMenuItem: NSMenuItem!
  var currentItem: DragItem?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Destination View
    destinationView.delegate = self
    view.addSubview(destinationView)

    saveMenuItem = (NSApplication.shared().delegate as! AppDelegate).saveMenuItem
    saveMenuItem?.target = self
    saveMenuItem.action = #selector(handleSaveCommand)
    saveMenuItem.isEnabled = false

    // Loading
    view.addSubview(loadingIndicator)
    activate(
      loadingIndicator.anchor.center,
      loadingIndicator.anchor.size.equal.to(100)
    )

    // Hide by default
    loadingIndicator.hide()
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

    self.currentItem = item

    saveMenuItem.isEnabled = true
    Utils.resize(window: window, image: item.image)
  }

  func handleSaveCommand() {
    guard let window = view.window,
      let item = currentItem else {
      return
    }

    loadingIndicator.show()
    item.save(window: window, completion: { [weak self] in
      DispatchQueue.main.async {
        self?.loadingIndicator.hide()
      }
    })
  }
}


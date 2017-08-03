import Cocoa

class ViewController: NSViewController, DestinationViewDelegate {

  let destinationView = DestinationView()
  var saveMenuItem: NSMenuItem!

  var currentItem: DragItem?

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

    self.currentItem = item

    saveMenuItem.isEnabled = true
    Utils.resize(window: window, image: item.image)

    item.afterDrag(window: window)
  }

  func handleSaveCommand() {
    guard let window = view.window,
      let item = currentItem else {
      return
    }

    item.save(window: window)
  }
}


import Cocoa

class ViewController: NSViewController, DestinationViewDelegate {

  let destinationView = DestinationView()

  override func viewDidLoad() {
    super.viewDidLoad()

    destinationView.delegate = self
    view.addSubview(destinationView)
  }

  override func viewDidLayout() {
    super.viewDidLayout()

    destinationView.frame = view.bounds
  }

  // MARK: - DestinationViewDelegate

  func destinationView(_ view: DestinationView, didGetImage image: NSImage) {
    guard let window = view.window else {
      return
    }

    let frame = NSRect(origin: window.frame.origin, size: image.size)
    window.setFrame(frame, display: true)
  }
}


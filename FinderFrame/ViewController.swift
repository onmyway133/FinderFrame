import Cocoa

class ViewController: NSViewController {

  let destinationView = DestinationView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(destinationView)
  }

  override func viewDidLayout() {
    super.viewDidLayout()

    destinationView.frame = view.bounds
  }
}


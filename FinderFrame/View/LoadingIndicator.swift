import Cocoa
import Anchors

class LoadingIndicator: NSBox {

  var progressIndicator: NSProgressIndicator!

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)

    // Box
    boxType = .custom
    title = ""
    fillColor = NSColor.white.withAlphaComponent(0.5)
    cornerRadius = 5
    borderType = .noBorder

    // Progress
    progressIndicator = NSProgressIndicator()
    progressIndicator.style = .spinningStyle
    progressIndicator.isDisplayedWhenStopped = false
    progressIndicator.startAnimation(nil)

    addSubview(progressIndicator)
    activate(
      progressIndicator.anchor.center
    )
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  func show() {
    alphaValue = 1.0
  }

  func hide() {
    alphaValue = 0
  }
}

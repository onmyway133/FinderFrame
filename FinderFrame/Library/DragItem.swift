import Cocoa

protocol DragItem {
  /// Name of the file
  var name: String { get }

  /// The first image, used to display in the view
  var image: NSImage { get }

  // Applye reprocess when item has just been dragged
  func afterDrag(window: NSWindow)

  // Save
  func save(window: NSWindow)
}

extension DragItem {
  func afterDrag(window: NSWindow) {
    
  }
}

import Cocoa

protocol DragItem {
  /// Name of the file
  var name: String { get }

  /// The first image, used to display in the view
  var image: NSImage { get }  //
}

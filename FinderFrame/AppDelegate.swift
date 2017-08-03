//
//  AppDelegate.swift
//  FinderFrame
//
//  Created by Khoa Pham on 29.06.2017.
//  Copyright © 2017 Fantageek. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var saveMenuItem: NSMenuItem!

  func applicationDidFinishLaunching(_ aNotification: Notification) {

    NSUserNotificationCenter.default.delegate = self
  }
}

extension AppDelegate: NSUserNotificationCenterDelegate {

  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return true
  }

  func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
    guard let text = notification.informativeText,
      let url = URL(string: text) else {
        return
    }

    NSWorkspace.shared().activateFileViewerSelecting([url])
  }
}

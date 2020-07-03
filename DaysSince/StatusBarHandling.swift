//
//  StatusBarHandling.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa

//MARK: constants
fileprivate let statusBarIconSize = 22

class StatusBarItemHandler: NSObject {
  private var statusBarItem: NSStatusItem?
  
  private func makeItem() {
    let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    statusBarItem.menu = menu
    
    let image = NSImage(named: "StatusBarIcon")
    image?.size = NSSize(width: statusBarIconSize, height: statusBarIconSize)
    statusBarItem.button?.image = image
    statusBarItem.button?.imagePosition = .imageLeading
    statusBarItem.button?.title = "Day \(daysToMark)"
    
    self.statusBarItem = statusBarItem
  }
  
  // MARK: public
  
  var menu: NSMenu? {
    didSet {
      statusBarItem?.menu = menu
    }
  }
  
  var daysToMark: Int = 0 {
    didSet {
      statusBarItem?.button?.title = "Day \(daysToMark)"
    }
  }

  var enabled: Bool = false {
    didSet {
      if enabled {
        makeItem()
      } else {
        statusBarItem = nil
      }
    }
  }
}

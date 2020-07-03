//
//  StatusBarHandling.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa

final class StatusBarItemHandler: NSObject {
  private let statusBarIconSize = 22
  
  private var statusBarItem: NSStatusItem!
  private var menu: NSMenu?
  
  init(_ menu: NSMenu?) {
    super.init()
    self.menu = menu
    makeItem()
  }
  
  private func makeItem() {
    statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    statusBarItem.menu = menu
    
    let image = NSImage(named: "StatusBarIcon")
    image?.size = NSSize(width: statusBarIconSize, height: statusBarIconSize)
    statusBarItem.button?.image = image
    statusBarItem.button?.imagePosition = .imageLeading
    
    statusBarItem.button?.title = "Day \(daysToMark)"
  }
  
  // MARK: public
  
  var daysToMark: Int = 0 {
    didSet {
      statusBarItem.button?.title = "Day \(daysToMark)"
    }
  }

  var enabled: Bool = true {
    didSet {
      if enabled {
        makeItem()
      } else {
        statusBarItem = nil
      }
    }
  }
}

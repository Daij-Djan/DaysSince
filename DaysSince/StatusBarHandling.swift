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
  private var handler: (() -> Void)!
  
  init(_ handler: @escaping () -> Void ) {
    super.init()
    
    self.handler = handler
    makeItem()
  }
  
  private func makeItem() {
    statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    statusBarItem.button?.action = #selector(StatusBarItemHandler.handleClick(_:))
    statusBarItem.button?.target = self

    let image = NSImage(named: "StatusBarIcon")
    image?.size = NSSize(width: statusBarIconSize, height: statusBarIconSize)
    statusBarItem.button?.image = image
    statusBarItem.button?.imagePosition = .imageLeading
    
    statusBarItem.button?.title = "Day \(daysToMark)"
  }
  
  @objc private func handleClick(_:AnyClass) {
    handler()
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

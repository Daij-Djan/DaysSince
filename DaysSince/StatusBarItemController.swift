//
//  StatusBarItemController.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa

//MARK: constants
fileprivate let statusBarIconSize = 22

struct StatusBarItemController {
  private var statusBarItem: NSStatusItem?
    
  private var title: String {
    return String(format: NSLocalizedString("Day %d", comment: "Days marker in menubar"), daysToMark)
  }
  
  private var image: NSImage? {
    let image = NSImage(named: "StatusBarIcon")
    image?.size = NSSize(width: statusBarIconSize, height: statusBarIconSize)
    return image
  }
  
  //MARK: public
  
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
        let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.menu = menu

        let button = statusBarItem.button!
        button.title = title
        button.font = NSFont.systemFont(ofSize: 13)
        button.image = image
        button.imagePosition = .imageLeading
        button.imageHugsTitle = true
        
        self.statusBarItem = statusBarItem
      } else {
        statusBarItem = nil
      }
    }
  }
}

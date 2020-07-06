//
//  DesktopWindowController.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa

struct DesktopWindowController {
  private var window : NSWindow?;

  // MARK: public
  
  var daysToMark: Int = 0 {
    didSet {
      guard let vc = window?.contentViewController as? MarkingsViewController else {
        return;
      }
      vc.daysToMark = daysToMark
    }
  }
  
  var scalingFactor: Double = 1.0 {
    didSet {
      guard let vc = window?.contentViewController as? MarkingsViewController else {
        return;
      }
      vc.scalingFactor = scalingFactor
    }
  }
  
  var direction: FlowDirection = .flowHorizontally {
    didSet {
      guard let vc = window?.contentViewController as? MarkingsViewController else {
        return;
      }
      vc.direction = direction
    }
  }

  var enabled: Bool = false {
    didSet {
      if enabled {
        let window = NSWindow(contentRect: NSScreen.main!.visibleFrame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.ignoresMouseEvents = true
        window.backgroundColor = .clear
        window.collectionBehavior = [.stationary, .canJoinAllSpaces]
        window.level = .init(rawValue: NSWindow.Level.normal.rawValue - 1)
        
        #if DEBUG
        if DebuggerUtils.isDebuggerAttached() {
          print("keep window normal for easier debugging")
          window.level = .normal
        }
        #endif

        let vc = MarkingsViewController()
        vc.daysToMark = daysToMark
        vc.scalingFactor = scalingFactor
        vc.direction = direction
        vc.view.frame = NSScreen.main!.visibleFrame
        window.contentViewController = vc
        
        self.window = window
        window.orderFrontRegardless()
      } else {
        window?.orderOut(nil)
        window = nil
      }
    }
  }
}

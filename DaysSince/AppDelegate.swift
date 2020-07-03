//
//  AppDelegate.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet private var prefsWindow: NSWindow?
  private let settings = Settings()
  private let statusBarItemHandler = StatusBarItemHandler()
  private let desktopWindowHandler = DesktopWindowHandler()
      
  // MARK: NSApplicationDelegate
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    //init UI
    statusBarItemHandler.menu = NSApp.mainMenu?.items.first?.submenu
    desktopWindowHandler.enabled = true

    //if we toggle dock icon visibility, osx hides our windows. dont let it
    for window in NSApp.windows {
      window.canHide = false
    }

    //prepare settings
    settings.observe { switch($0) {
      case .scale, .date, .direction:               self.updateUI()
      case .dockIcon, .statusBarItem, .openAtLogin: self.updateAppSettings()
    }}

    //show prefs if needed
    if settings.isEmpty {
      showPrefs(self)
    }
  }
  
  //MARK: helpers
  
  @IBAction private func showPrefs(_:Any) {
    NSApp.activate(ignoringOtherApps: true)
    prefsWindow?.makeKeyAndOrderFront(self)
  }
  
  private func updateUI() {
    let days = settings.daysToMark
    statusBarItemHandler.daysToMark = days
    desktopWindowHandler.daysToMark = days
    desktopWindowHandler.scalingFactor = settings.scalingFactor
    desktopWindowHandler.direction = settings.direction
  }
  
  private func updateAppSettings() {
    NSApp.setActivationPolicy(settings.showDockIcon ? .regular : .accessory)
    NSApp.activate(ignoringOtherApps: true)
    
    statusBarItemHandler.enabled = settings.showStatusBarItem

    let shouldOpenAtLogin = settings.shouldOpenAtLogin
    if LaunchAtLogin.isEnabled != shouldOpenAtLogin {
      LaunchAtLogin.isEnabled = shouldOpenAtLogin
    }
  }

}

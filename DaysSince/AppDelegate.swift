//
//  AppDelegate.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet private var prefsWindow: NSWindow!
  private var settings: Settings!
  private var statusBarItemHandler: StatusBarItemHandler!
  private var desktopWindowHandler: DesktopWindowHandler!
    
  private func showPrefs() {
    NSApp.activate(ignoringOtherApps: true)
    prefsWindow.makeKeyAndOrderFront(self)
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
  
  // MARK: NSApplicationDelegate
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    //prepare settings
    settings = Settings() { switch($0) {
      case .scale, .date, .direction:               self.updateUI()
      case .dockIcon, .statusBarItem, .openAtLogin: self.updateAppSettings()
    }}

    //init UI
    statusBarItemHandler = StatusBarItemHandler() { self.showPrefs() }
    desktopWindowHandler = DesktopWindowHandler()
    //show prefs if needed
    if settings.isEmpty {
      showPrefs()
    }
    
    //if we toggle dock icon visibility, osx hides our windows. dont let it
    for window in NSApp.windows {
      window.canHide = false
    }
  }
}

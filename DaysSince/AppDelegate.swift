//
//  AppDelegate.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject {
  @IBOutlet private var prefsWindow: NSWindow?
  private lazy var statusBarItemController = StatusBarItemController()
  private lazy var desktopWindowController = DesktopWindowController()

  @IBAction private func showPrefs(_:Any) {
    NSApp.activate(ignoringOtherApps: true)
    prefsWindow?.makeKeyAndOrderFront(self)
  }
}

extension AppDelegate: NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    //prepare our UI Windows
    statusBarItemController.menu = NSApp.mainMenu?.items.first?.submenu
    desktopWindowController.enabled = true

    //Workaround for dock icon visibility toggle: osx hides our windows on becoming .accessory. dont let it
    for window in NSApp.windows {
      window.canHide = false
    }
    
    //prepare settings
    UserDefaults.standard.applyInitialValues()
    UserDefaults.standard.beginObservingKeys(observer: self)
    
    //show prefs if needed
    if UserDefaults.standard.firstRun {
      UserDefaults.standard.firstRun = false
      showPrefs(self)
    }
  }
}

extension AppDelegate {
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    applySettings()
  }
  
  private func applySettings() {
    //apply dock icon
    NSApp.setActivationPolicy(UserDefaults.standard.dockIcon ? .regular : .accessory)
    NSApp.activate(ignoringOtherApps: true)

    //update statusbar
    statusBarItemController.daysToMark = Date().daysSince(UserDefaults.standard.date)
    statusBarItemController.enabled = UserDefaults.standard.statusBarItem

    //manage Start at Login
    let shouldOpenAtLogin = UserDefaults.standard.openAtLogin
    if LaunchAtLogin.isEnabled != shouldOpenAtLogin {
      LaunchAtLogin.isEnabled = shouldOpenAtLogin
    }

    //update desktop window
    desktopWindowController.daysToMark = Date().daysSince(UserDefaults.standard.date)
    desktopWindowController.scalingFactor = UserDefaults.standard.scale
    desktopWindowController.direction = UserDefaults.standard.direction
  }
}

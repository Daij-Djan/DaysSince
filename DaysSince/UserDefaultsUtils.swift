//
//  UserDefaultsUtils.swift
//  DaysSince
//
//  Created by Dominik Pich on 7/1/20.
//

import Foundation

extension UserDefaults {
  fileprivate struct Key {
    static var firstRun = "firstRun"
    static var date = "date"
    static var scale = "scale"
    static var direction = "direction"
    static var dockIcon = "dockIcon"
    static var statusBarItem = "statusBarItem"
    static var openAtLogin = "openAtLogin"
    static var enabledLauncherId = "enabledLauncher"
    
    static var all = [firstRun, date, scale, direction, dockIcon, statusBarItem, openAtLogin, enabledLauncherId]
  }

  var firstRun: Bool {
    get {
      return bool(forKey: Key.firstRun)
    }
    set {
      setValue(newValue, forKey: Key.firstRun)
    }
  }
  
  var date: Date? {
    return object(forKey: Key.date) as? Date
  }

  var scale: Double {
    return double(forKey: Key.scale)
  }

  var direction: FlowDirection {
    return FlowDirection(rawValue: integer(forKey: Key.direction))!
  }
  
  var dockIcon: Bool {
    return bool(forKey: Key.dockIcon)
  }

  var statusBarItem: Bool {
    if !dockIcon {
      return true
    }
    return bool(forKey: Key.statusBarItem)
  }
  
  var openAtLogin: Bool {
    return bool(forKey: Key.openAtLogin)
  }

  var enabledLauncherId: String? {
    get {
      return string(forKey: Key.enabledLauncherId)
    }
    set {
      if newValue != nil {
        setValue(newValue, forKey: Key.enabledLauncherId)
      } else {
        removeObject(forKey: Key.enabledLauncherId)
      }
    }
  }

  func applyInitialValues() {
    self.register(defaults: [
      Key.firstRun : true,
      Key.date : Date.startOfMyQuarantine,
      Key.scale : 1.0,
      Key.direction : FlowDirection.flowVertically.rawValue,
      Key.dockIcon : true,
      Key.statusBarItem : true,
      Key.openAtLogin : false,
    ])
  }
  
  func beginObservingKeys(observer: NSObject) {
    for key in Key.all {
      self.addObserver(observer, forKeyPath: key, options: [.initial, .new], context: nil)
    }
  }
  
  func endObservingKeys(observer: NSObject) {
    for key in Key.all {
      self.removeObserver(observer, forKeyPath: key)
    }
  }
}


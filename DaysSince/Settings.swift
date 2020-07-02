//
//  Settings.swift
//  DaysSince
//
//  Created by Dominik Pich on 7/1/20.
//

import Foundation

fileprivate extension UserDefaults {
  @objc dynamic var date: Date? {
    return object(forKey: "date") as? Date
  }

  @objc dynamic var scale: NSNumber? {
    object(forKey: "scale") as? NSNumber
  }

  @objc dynamic var direction: NSNumber? {
    object(forKey: "direction") as? NSNumber
  }
  
  @objc dynamic var dockIcon: NSNumber? {
    object(forKey: "dockIcon") as? NSNumber
  }

  @objc dynamic var statusBarItem: NSNumber? {
    object(forKey: "statusBarItem") as? NSNumber
  }
  
  @objc dynamic var openAtLogin: NSNumber? {
    object(forKey: "openAtLogin") as? NSNumber
  }
}

final class Settings: NSObject {
  enum SettingsKey {
    case date
    case scale
    case direction
    case dockIcon
    case statusBarItem
    case openAtLogin
  }
  
  private var handler: ((SettingsKey) -> Void)!
  private var tokens = [NSKeyValueObservation?]()
  
  init(_ handler: @escaping (SettingsKey) -> Void ) {
    self.handler = handler
    super.init()
    
    DispatchQueue.main.async {
      self.observeSetting(\.date, .date)
      self.observeSetting(\.scale, .scale)
      self.observeSetting(\.direction, .direction)
      self.observeSetting(\.dockIcon, .dockIcon)
      self.observeSetting(\.statusBarItem, .statusBarItem)
      self.observeSetting(\.openAtLogin, .openAtLogin)
    }
  }
  
  private func observeSetting<Value>(_ path: KeyPath<UserDefaults, Value>, _ key: SettingsKey) {
    let token = UserDefaults.standard.observe(path, options: [.initial, .new]) { _,_ in self.handler(key) }
    tokens.append(token)
  }
  
  deinit {
    for token in tokens {
      token?.invalidate()
    }
  }

  // MARK: public
  
  var isEmpty: Bool {
    return UserDefaults.standard.date == nil
  }
  
  var daysToMark: Int {
    return Date().daysSince(UserDefaults.standard.date)
  }

  var scalingFactor: Double {
    guard let rawScale = UserDefaults.standard.scale else {
      return 1
    }
    return rawScale.doubleValue
  }
  
  var direction: DesktopWindowHandler.Direction {
    guard let rawDirection = UserDefaults.standard.direction,
          let direction = DesktopWindowHandler.Direction(rawValue: rawDirection.intValue) else {
      return .flowHorizontally
    }
    return direction
  }
  
  var showDockIcon: Bool {
    guard let rawDockIcon = UserDefaults.standard.dockIcon else {
      return true
    }
    return rawDockIcon.boolValue
  }
  
  var showStatusBarItem: Bool {
    if showDockIcon == false {
      return true
    }
    guard let rawStatusBarItem = UserDefaults.standard.statusBarItem else {
      return true
    }
    return rawStatusBarItem.boolValue
  }
  
  var shouldOpenAtLogin: Bool {
    guard let rawOpenAtLogin = UserDefaults.standard.openAtLogin else {
      return false
    }
    return rawOpenAtLogin.boolValue
  }
}



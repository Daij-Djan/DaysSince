//
//  DesktopHandling.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa
import CoreGraphics

fileprivate final class Cell: NSCollectionViewItem {
  override func loadView() {
    self.view = NSImageView()
  }
  
  func update(imageSetPrefix: Int, daysToMark: Int) {
    (view as? NSImageView)?.image = imageForIndexPath(imageSetPrefix, daysToMark)
  }

  private func imageForIndexPath(_ imageSetPrefix: Int, _ daysToMark: Int) -> NSImage? {
    return NSImage(named: "\(imageSetPrefix).\(daysToMark)")
  }
}

fileprivate final class Window: NSWindow {
  init() {
    super.init(contentRect: NSScreen.main!.visibleFrame,
               styleMask: [.borderless],
               backing: .buffered,
               defer: false)
    ignoresMouseEvents = true
    backgroundColor = .clear
    collectionBehavior = [.stationary, .canJoinAllSpaces]
    level = .init(rawValue: NSWindow.Level.normal.rawValue - 1)
    #if DEBUG
    if AmIBeingDebugged() {
      print("keep window normal for easier debugging")
      level = .normal
    }
    #endif
  }
}

final class DesktopWindowHandler: NSObject, NSCollectionViewDataSource {
  enum Direction : Int {
    case flowHorizontally = 0
    case flowVertically = 1
  }

  private let defaultItemSize = 50.0
  private let numberOfSets = 5
  private let maxCountPerBlock = 5
  private let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "Cell")
  
  private var window: Window!
  private var collectionView: NSCollectionView!
  private var flowLayout: NSCollectionViewFlowLayout!
  
  override init() {
    super.init()
    
    //prepare collectionView
    flowLayout = NSCollectionViewFlowLayout()
    collectionView = NSCollectionView()
    collectionView.dataSource = self
    collectionView.collectionViewLayout = flowLayout
    collectionView.backgroundColors = [.clear]
    collectionView.register(Cell.self, forItemWithIdentifier: cellIdentifier)
    
    //create window
    window = Window()
    if let view = window.contentView {
      collectionView.frame = view.bounds
      view.addSubview(collectionView)
    }
    
    window.orderFront(self)
  }
   
  //MARK: collectionView data source
  
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    let fullBlocks = daysToMark / maxCountPerBlock
    let rest = daysToMark % maxCountPerBlock

    return fullBlocks + (rest > 0 ? 1 : 0)
  }

  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(withIdentifier: cellIdentifier, for: indexPath) as! Cell

    let fullBlocks = daysToMark / maxCountPerBlock
    let rest = daysToMark % maxCountPerBlock

    let imageSetPrefix = (indexPath.item % numberOfSets) + 1
    let daysToMark = (indexPath.item < fullBlocks ? maxCountPerBlock : rest)
    cell.update(imageSetPrefix: imageSetPrefix, daysToMark: daysToMark)
    
    return cell
  }
  
  // MARK: public
  
  var daysToMark: Int = 0 {
    didSet {
      collectionView.reloadData()
    }
  }
  
  var scalingFactor: Double = 1.0 {
    didSet {
      flowLayout.itemSize = NSSize(width: defaultItemSize * scalingFactor,
                                   height: defaultItemSize * scalingFactor)
    }
  }
  
  var direction: Direction = .flowHorizontally {
    didSet {
      switch(direction) {
      case .flowHorizontally: flowLayout.scrollDirection = .vertical
      case .flowVertically: flowLayout.scrollDirection = .horizontal
      }
    }
  }
}

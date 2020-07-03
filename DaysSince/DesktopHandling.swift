//
//  DesktopHandling.swift
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Cocoa
import CoreGraphics

//MARK: constants
fileprivate let defaultItemSize = 50.0
fileprivate let numberOfSets = 5
fileprivate let maxCountPerBlock = 5
fileprivate let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "Cell")

class DesktopWindowHandler: NSObject, NSCollectionViewDataSource {
  fileprivate class Cell: NSCollectionViewItem {
    override func loadView() {
      self.view = NSImageView()
    }
    
    func update(imageSetPrefix: Int, daysToMark: Int) {
      if let imageView = view as? NSImageView {
        imageView.image = NSImage(named: "\(imageSetPrefix).\(daysToMark)")
      }
    }
  }

  fileprivate class Window: NSWindow {
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
      if DebuggerAttached() {
        print("keep window normal for easier debugging")
        level = .normal
      }
      #endif
    }
  }

  enum Direction : Int {
    case flowHorizontally = 0
    case flowVertically = 1
  }

  private let window = Window()
  private let collectionView = NSCollectionView()
  private let flowLayout = NSCollectionViewFlowLayout()
  
  override init() {
    super.init()
    
    //prepare collectionView
    collectionView.dataSource = self
    collectionView.collectionViewLayout = flowLayout
    collectionView.backgroundColors = [.clear]
    collectionView.register(Cell.self, forItemWithIdentifier: cellIdentifier)
    
    //create window
    if let view = window.contentView {
      collectionView.frame = view.bounds
      view.addSubview(collectionView)
    }
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

  var enabled: Bool = false {
    didSet {
      if enabled {
        window.orderFrontRegardless()
      } else {
        window.close()
      }
    }
  }
}

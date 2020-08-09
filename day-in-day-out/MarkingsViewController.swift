//
//  MarkingsViewController.swift
//  day-in-day-out
//
//  Created by Dominik Pich on 7/6/20.
//

import Cocoa
import CoreGraphics

//MARK: constants
fileprivate let defaultItemSize = 50.0
fileprivate let numberOfSets = 5
fileprivate let maxCountPerBlock = 5
fileprivate let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "Cell")

enum FlowDirection : Int {
  case flowHorizontally = 0
  case flowVertically = 1
}

class MarkingsViewController: NSViewController {
  override func loadView() {
    //build layout
    let flowLayout = NSCollectionViewFlowLayout()
    flowLayout.itemSize = NSSize(width: defaultItemSize * scalingFactor,
                                 height: defaultItemSize * scalingFactor)
    switch(direction) {
    case .flowHorizontally:
      flowLayout.scrollDirection = .vertical
    case .flowVertically:
      flowLayout.scrollDirection = .horizontal
    }

    //build collection
    let collectionView = NSCollectionView()
    collectionView.dataSource = self
    collectionView.collectionViewLayout = flowLayout
    collectionView.backgroundColors = [.clear]
    collectionView.register(CollectionViewCell.self, forItemWithIdentifier: cellIdentifier)
    view = collectionView
  }
  
  private var currentCollectionView : NSCollectionView? {
    return view as? NSCollectionView
  }
  
  private var currentFlowLayout : NSCollectionViewFlowLayout? {
    return currentCollectionView?.collectionViewLayout as? NSCollectionViewFlowLayout
  }
  
  // MARK: public
  
  var daysToMark: Int = 0 {
    didSet {
      currentCollectionView?.reloadData()
    }
  }
  
  var scalingFactor: Double = 1.0 {
    didSet {
      currentFlowLayout?.itemSize = NSSize(width: defaultItemSize * scalingFactor,
                                           height: defaultItemSize * scalingFactor)
    }
  }
  
  var direction: FlowDirection = .flowHorizontally {
    didSet {
      switch(direction) {
      case .flowHorizontally:
        currentFlowLayout?.scrollDirection = .vertical
      case .flowVertically:
        currentFlowLayout?.scrollDirection = .horizontal
      }
    }
  }
}

extension MarkingsViewController: NSCollectionViewDataSource {
  func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    let fullBlocks = daysToMark / maxCountPerBlock
    let rest = daysToMark % maxCountPerBlock
    
    return fullBlocks + (rest > 0 ? 1 : 0)
  }
  
  func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(withIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
    
    let fullBlocks = daysToMark / maxCountPerBlock
    let rest = daysToMark % maxCountPerBlock
    
    let imageSetPrefix = (indexPath.item % numberOfSets) + 1
    let daysToMark = (indexPath.item < fullBlocks ? maxCountPerBlock : rest)
    cell.update(imageSetPrefix: imageSetPrefix, daysToMark: daysToMark)
    
    return cell
  }
}

fileprivate class CollectionViewCell: NSCollectionViewItem {
  override func loadView() {
    self.view = NSImageView()
  }
  
  func update(imageSetPrefix: Int, daysToMark: Int) {
    if let imageView = view as? NSImageView {
      imageView.contentTintColor = NSColor(named: "AccentColor")
      imageView.image = NSImage(named: "\(imageSetPrefix).\(daysToMark)")
    }
  }
}

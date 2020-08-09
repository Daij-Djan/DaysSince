//
//  DateUtils
//  day-in-day-out
//
//  Created by Dominik Pich on 6/27/20.
//

import Foundation

extension Date {
  func daysGone(since date: Date?) -> Int {
    guard let sinceDate = date else {
      return 0
    }
    
    let calendar = Calendar.current
    let date1 = calendar.startOfDay(for: sinceDate)
    let date2 = calendar.startOfDay(for: self)
    let components = calendar.dateComponents([.day], from: date1, to: date2)
    return components.day ?? 0
  }
  
  static var startOfMyQuarantine: Date {
    var components = DateComponents()
    components.setValue(5, for: .day)
    components.setValue(3, for: .month)
    components.setValue(2019, for: .year)
    return Calendar.current.date(from: components)!
  }
}

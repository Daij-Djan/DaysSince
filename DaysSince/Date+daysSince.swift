//
//  Extensions
//  DaysSince
//
//  Created by Dominik Pich on 6/27/20.
//

import Foundation

extension Date {
  func daysSince(_ date: Date?) -> Int {
    var daysSince = 0
    if let sinceDate = date  {
      let calendar = Calendar.current
      
      let date1 = calendar.startOfDay(for: sinceDate)
      let date2 = calendar.startOfDay(for: self)
      let components = calendar.dateComponents([.day], from: date1, to: date2)
      daysSince = components.day ?? 0
    }
    
    return daysSince
  }
}

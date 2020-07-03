//
//  AmIBeingDebugged.swift
//  DaysSince
//
//  Created by Dominik Pich on 7/2/20.
//

import Foundation

func DebuggerAttached() -> Bool {
  var info = kinfo_proc()
  var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
  var size = MemoryLayout<kinfo_proc>.stride
  let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
  assert(junk == 0, "sysctl failed")
  return (info.kp_proc.p_flag & P_TRACED) != 0
}

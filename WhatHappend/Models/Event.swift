//
//  Group.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import Foundation
import Combine

struct WHEventForUpate: Codable {
  
}

// [月-[日-次数]]
typealias WHRecords = Dictionary<String, Dictionary<Int, Int>>

final class WHEvent: Identifiable, ObservableObject {
  let uuid: UUID
  
  @Published var name: String
  var asDailyTarget: Bool
  var targetCount: Int?
  var targetUnit: String?
  @Published var records: WHRecords
  
  var monthDistribution: [Int] {
    let date = Date()
    let (_, end) = Calendar.containingMonth(date)
    let lastDay = end.day
    
    guard let _records = records[date.yearMonthString] else {
      return Array.init(repeating: 0, count: lastDay)
    }
    
    var array: [Int] = []
    for d in 1...lastDay {
      array.append(_records[d] == nil ? 0 : _records[d]!)
    }
    
    return array
  }
  
  func addRecord() -> Void {
    let date = Date()
    if records[date.yearMonthString] == nil {
      records[date.yearMonthString] = [:]
    }
    // always true
    if var _records = records[date.yearMonthString] {
      if let count = _records[date.day] {
        _records[date.day] = count + 1
      } else {
        _records[date.day] = 1
      }
      records[date.yearMonthString] = _records
    }
    if UserDefaults.standard.string(forKey: "username") != nil {
//      makeRequest(
//        url:WHRequestConfig.baseURL + "/group/\(uuid.uuidString)/time",
//        config: jsonConfig(data: try? JSONEncoder().encode(time), method: "POST"),
//        success: { res in
//          DispatchQueue.main.async {
//            self.times.append(try! JSONDecoder().decode(WhatServerResponse<WhatTime>.self, from: res).data!)
//            self._countsGroupedByYear = nil
//            self._datesGroupedByMonth = nil
//          }
//        }
//      )
    } else {
      WHManager.current.saveAsJson(event: self)
    }
  }
  
  func resetToday() {
    let date = Date()
    if records[date.yearMonthString] != nil {
      (records[date.yearMonthString]!)[date.day] = nil
    }
    if UserDefaults.standard.string(forKey: "username") != nil {
      
    } else {
      WHManager.current.saveAsJson(event: self)
    }
  }
  
  
  func updateFrom(_ from: WHEventForUpate) {
//    if UserDefaults.standard.string(forKey: "username") != nil {
//      makeRequest(
//        url: WHRequestConfig.baseURL + "/group/:\(uuid.uuidString)",
//        config: jsonConfig(data: try? JSONEncoder().encode(from), method: "PUT"),
//        success: { _ in
//          self.name = from.name
//          self.emotion = from.emotion
//        }
//      )
//    } else {
//      name = from.name
//      emotion = from.emotion
//      WHManager.current.saveAsJson(updateCounts: false, updateNames: true)
//    }
  }
  
  
  func getDayCount(month: String, day: Int) -> Int {
    guard let _records = records[month] else {
      return 0
    }
    guard let count = _records[day] else {
      return 0
    }
    return count
  }
  
  func getDayCount(date: Date) -> Int {
    getDayCount(month: date.yearMonthString, day: date.day)
  }
  
  func getDayProgress(month: String, day: Int) -> Float {
    let count = getDayCount(month: month, day: day)
    guard asDailyTarget else {
      return 0
    }
    return Float(count) / Float(targetCount!)
  }
  
  func getDayProgress(date: Date) -> Float {
    getDayProgress(month: date.yearMonthString, day: date.day)
  }
  
  init(
    name: String,
    asDailyTarget: Bool,
    targetCount: Int?,
    targetUnit: String?,
    records: WHRecords,
    uuid: UUID = UUID()
  ) {
    self.name = name
    self.asDailyTarget = asDailyTarget
    self.targetCount = targetCount
    self.targetUnit = targetUnit
    self.records = records
    self.uuid = uuid
  }
  
  // 快速创建一个非每日目标的事件
  convenience init(name: String) {
    self.init(name: name, asDailyTarget: false, targetCount: nil, targetUnit: nil, records: [:])
  }
  
  convenience init(from: WHEventCodable) {
    self.init(
      name: from.name,
      asDailyTarget: from.asDailyTarget,
      targetCount: from.targetCount,
      targetUnit: from.targetUnit,
      records: from.records,
      uuid: from.uuid
    )
  }
}

struct WHEventCodable: Codable {
  let uuid: UUID
  var name: String
  var asDailyTarget: Bool
  var targetCount: Int?
  var targetUnit: String?
  var records: WHRecords
  
  init(from: WHEvent) {
    uuid = from.uuid
    name = from.name
    asDailyTarget = from.asDailyTarget
    targetCount = from.targetCount
    targetUnit = from.targetUnit
    records = from.records
  }
}

extension Date {
  var year: Int {
    Calendar.current.dateComponents([.year], from: self).year!
  }
  
  var yearMonthString: String {
    let components = Calendar.current.dateComponents([.year, .month], from: self)
    return  "\(components.year!)-\(components.month!)"
  }
  
  var day: Int {
    Calendar.current.dateComponents([.day], from: self).day!
  }
  
  var weekDay: Int {
    Calendar.current.dateComponents([.weekday], from: self).weekday!
  }
}

extension Calendar {
  static func containingMonth(_ date: Date) -> (Date, Date) {
    let interval = Calendar.current.dateInterval(of: .month, for: date)
    return (interval!.start, Calendar.current.date(byAdding: .second, value: -1, to: interval!.end)!)
  }
  
  static func prevMonth(_ date: Date) -> (Date, Date) {
    let (start, _) = Calendar.containingMonth(date)
    return (
      Calendar.current.date(byAdding: .month, value: -1, to: start)!,
      Calendar.current.date(byAdding: .second, value: -1, to: start)!
    )
  }
  
  static func nextMonth(_ date: Date) -> (Date, Date) {
    let (_, end) = Calendar.containingMonth(date)
    return (
      Calendar.current.date(byAdding: .second, value: 1, to: end)!,
      Calendar.current.date(byAdding: .month, value: 1, to: end)!
    )
  }
}

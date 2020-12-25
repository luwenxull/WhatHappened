//
//  Group.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import Foundation
import Combine

enum WhatEmotion: Int, Codable {
  case happy, unhappy
}

struct WhatTime: Hashable, Codable {
  var _id: String? = nil
  var date: Date = Date()
  var description: String = ""
}

struct WHEventForUpate: Codable {
  let name: String
  let emotion: WhatEmotion
}

typealias WHRecords = Dictionary<String, Dictionary<String, Int>>

final class WHEvent: Identifiable, ObservableObject {
  let uuid: UUID
  
  @Published var name: String
  var asDailyTarget: Bool
  var targetCount: Int?
  var targetUnit: String?
  var records: WHRecords
  
  func addRecord(_ time: WhatTime) -> Void {
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
//      times.append(time)
//      _countsGroupedByYear = nil
//      _datesGroupedByMonth = nil
//      WHManager.current.saveAsJson(updateCounts: true, updateNames: false)
    }
  }
  
  func removeRecord(_ index: Int) -> Void {
//    let time = times[index]
    if UserDefaults.standard.string(forKey: "username") != nil {
//      makeRequest(
//        url: WHRequestConfig.baseURL + "/group/time/\(time._id!)",
//        config: jsonConfig(data: nil, method: "DELETE"),
//        success: { _ in
//          DispatchQueue.main.async {
//            self.times.remove(at: index)
//            self._countsGroupedByYear = nil
//            self._datesGroupedByMonth = nil
//          }
//        }
//      )
    } else {
//      times.remove(at: index)
//      _countsGroupedByYear = nil
//      _datesGroupedByMonth = nil
//      WHManager.current.saveAsJson(updateCounts: true, updateNames: false)
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
    let components = Calendar.current.dateComponents([.year], from: self)
    return components.year!
  }
  
  var yearMonthString: String {
    let components = Calendar.current.dateComponents([.year, .month], from: self)
    return  "\(components.year!)-\(components.month!)"
  }
  
  var day: Int {
    let components = Calendar.current.dateComponents([.day], from: self)
    return components.day!
  }
}

extension Calendar {
  static func lastDayOfMonth(_ date: Date) -> Date {
    let end = Calendar.current.dateInterval(of: .month, for: date)?.end
    return Calendar.current.date(byAdding: .second, value: -1, to: end!)!
  }
}

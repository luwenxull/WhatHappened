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
  var date: Date = Date()
  var description: String = ""
}

final class WhatGroup: Identifiable, ObservableObject {
  let name: String
  let emotion: WhatEmotion
  @Published var times: [WhatTime] {
    didSet {
      WhatManager.current.saveAsJson()
    }
  }
  
  var dirty: Bool = true
  var cancelable: AnyCancellable?
  var _datesGroupedByMonth: [String: [Date]]?
  var datesGroupedByMonth: [String: [Date]] {
    if dirty || _datesGroupedByMonth == nil {
      var all = [String: [Date]]()
      for time in times {
        let month = time.date.month
        if all[month] == nil {
          all[month] = []
        }
        all[month]?.append(time.date)
      }
      _datesGroupedByMonth = all
      dirty = false
    }
    return _datesGroupedByMonth!
  }
  
  func addRecord(_ time: WhatTime) -> Void {
    times.append(time)
  }
  
  func removeRecord(_ index: Int) -> Void {
    times.remove(at: index)
  }
  
  init(name: String, emotion: WhatEmotion, times: [WhatTime]) {
    self.name = name
    self.emotion = emotion
    self.times = times
    
    self.cancelable = $times.sink(receiveValue: { [weak self]_ in
      self?.dirty = true
    })
  }
}

extension WhatGroup: Codable {
  enum CodingKeys: CodingKey {
    case name, emotion, times
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(emotion, forKey: .emotion)
    try container.encode(times, forKey: .times)
  }
  
   convenience init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let name = try values.decode(String.self, forKey: .name)
    let emotion = try values.decode(WhatEmotion.self, forKey: .emotion)
    let times = try values.decode(Array<WhatTime>.self, forKey: .times)
    self.init(name: name, emotion: emotion, times: times)
  }
}

extension Date {
  var month: String {
    let components = Calendar.current.dateComponents(Set([.year, .month]), from: self)
    let month = String(components.month!)
    return String(components.year!) + "-" + (month.count == 2 ? month : "0\(month)")
  }
  
  var day: Int {
    let components = Calendar.current.dateComponents(Set([.day]), from: self)
    return components.day!
  }
}

extension Calendar {
  static func lastDayOfMonth(_ date: Date) -> Date {
    let end = Calendar.current.dateInterval(of: .month, for: date)?.end
    return Calendar.current.date(byAdding: .second, value: -1, to: end!)!
  }
}

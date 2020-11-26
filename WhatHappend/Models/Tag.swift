//
//  Tag.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import Foundation

enum WhatEmotion {
  case happy, unhappy
}

struct WhatTime: Hashable {
  var date: Date = Date()
  var description: String = ""
}

class WhatTag: Identifiable, ObservableObject {
  let name: String
  let emotion: WhatEmotion
  @Published var times: [WhatTime]
  
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
  }
}

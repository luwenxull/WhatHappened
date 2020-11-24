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

struct WhatTag: Hashable {
  let name: String
  let emotion: WhatEmotion
  var times: [Date]
}

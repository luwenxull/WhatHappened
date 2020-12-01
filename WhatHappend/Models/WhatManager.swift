//
//  WhatManager.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import Foundation

class WhatManager: ObservableObject {
  @Published var tags: [WhatTag]
  
  init(tags: [WhatTag]) {
    self.tags = tags
  }
  
  func addTag(tag: WhatTag) {
    tags.append(tag)
  }
}

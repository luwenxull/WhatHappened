//
//  WhatManager.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import Foundation

class WhatManager: ObservableObject {
  let tags: [WhatTag]
  
  init(tags: [WhatTag]) {
    self.tags = tags
  }
}

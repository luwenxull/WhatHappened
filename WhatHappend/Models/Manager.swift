//
//  WhatManager.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import Foundation

class WhatManager: ObservableObject {
  @Published var groups: [WhatGroup]
  
  init(_ groups: [WhatGroup]) {
    self.groups = groups
  }
  
  func addGroup(_ group: WhatGroup) {
    groups.append(group)
  }
}

//
//  WhatHappendApp.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

@main
struct WhatHappendApp: App {
  let manager: WhatManager
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(manager)
    }
  }
  
  init() {
    let groups: [WhatGroup] = (try? load("groups.json")) ?? []
    manager = WhatManager(groups)
    WhatManager.current = manager
    print(FileManager.sharedContainerURL)
  }
}


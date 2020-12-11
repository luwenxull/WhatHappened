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
  @ObservedObject var hsm: HSController
  var body: some Scene {
    WindowGroup {
      ZStack {
        ContentView()
          .environmentObject(manager)
        hsm.view
      }
    }
  }
  
  init() {
    let groups: [WhatGroup] = (try? load("groups.json")) ?? []
    manager = WhatManager(groups)
    hsm = HSController()
    WhatManager.current = manager
    HSController.current = hsm
//    print(FileManager.sharedContainerURL)
  }
}


//
//  WhatHappendApp.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

@main
struct WhatHappendApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(WhatManager(tags: [
          WhatTag(name: "今天又下雨了", emotion: .unhappy, times: [Date()]),
          WhatTag(name: "今天打球了", emotion: .happy, times: [Date()]),
        ]))
    }
  }
}

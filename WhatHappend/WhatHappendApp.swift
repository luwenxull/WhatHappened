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
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return WindowGroup {
      ContentView()
        .environmentObject(WhatManager([
          WhatGroup(name: "今天又下雨了", emotion: .unhappy, times: [
            WhatTime(date: formatter.date(from: "2020-12-31")!, description: ".."),
            WhatTime(date: formatter.date(from: "2020-02-02")!, description: "..")
          ]),
          WhatGroup(name: "今天打球了", emotion: .happy, times: [WhatTime()]),
        ]))
    }
  }
}

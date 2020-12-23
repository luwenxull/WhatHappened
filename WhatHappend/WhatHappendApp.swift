//
//  WhatHappendApp.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI
import Combine

@main
struct WhatHappendApp: App {
  let manager: WHManager
  @ObservedObject var hsController: HSController
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        ContentView()
          .environmentObject(manager)
          .blur(radius: hsController.binding?.wrappedValue == true ? 3 : 0)
        if let binding = hsController.binding, let content = hsController.content {
          HalfSheetView(presented: binding, content: content)
        }
      }
    }
  }
  
  init() {
    manager = WHManager()
    hsController = HSController()
    WHManager.current = manager
    HSController.current = hsController
  }
}


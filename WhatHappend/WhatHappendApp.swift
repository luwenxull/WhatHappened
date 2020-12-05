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
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return WindowGroup {
      ContentView()
        .environmentObject(manager)
    }
  }
  
  init() {
    print(Bundle.main.bundleURL)
    let groups: [WhatGroup] = load("groups.json")
    manager = WhatManager(groups)
    WhatManager.current = manager
  }

}

func load<T: Decodable>(_ filename: String) -> T {
  let data: Data
  
  guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
  else {
    fatalError("Couldn't find \(filename) in main bundle.")
  }
  
  do {
    data = try Data(contentsOf: file)
  } catch {
    fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
  }
  
  do {
    let decoder = JSONDecoder()
    return try decoder.decode(T.self, from: data)
  } catch {
    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
  }
}

func save<T: Encodable>(filename: String, data: T) -> Void {
  guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
  else {
    fatalError("Couldn't find \(filename) in main bundle.")
  }
  
  let encoder = JSONEncoder()
  
  guard let encodeData = try? encoder.encode(data) else {
    fatalError("Couldn't encode \(filename).")
  }
  do {
    try encodeData.write(to: file)
  } catch {
    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
  }
}


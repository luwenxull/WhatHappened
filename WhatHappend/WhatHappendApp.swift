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
    let groups: [WhatGroup] = (try? load("groups.json")) ?? []
    manager = WhatManager(groups)
    WhatManager.current = manager
  }
}

extension FileManager {
  static var documentDirectoryURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

func load<T: Decodable>(_ filename: String) throws -> T {
  
  let fileURL = FileManager.documentDirectoryURL.appendingPathComponent(filename)
  
  let data = try Data(contentsOf: fileURL)
  let decoder = JSONDecoder()
  return try decoder.decode(T.self, from: data)
  
}

func save<T: Encodable>(filename: String, data: T) -> Void {
  let fileURL = FileManager.documentDirectoryURL.appendingPathComponent(filename)
  let encoder = JSONEncoder()
  
  guard let encodeData = try? encoder.encode(data) else {
    fatalError("Couldn't encode \(filename).")
  }
  
  do {
    try encodeData.write(to: fileURL)
  } catch {
    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
  }
}


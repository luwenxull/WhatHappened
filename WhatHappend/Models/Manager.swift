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
    self.saveAsJson()
  }
  
  func saveAsJson() {
    do {
      try save(filename: "groups.json", data: groups)
    } catch {
      print(error)
    }
    // 额外保存年度的计算数据
    var counts: [String: [Int: Int]] = [:]
    var names: [String: String] = [:]
    for group in groups {
      counts[group.uuid.uuidString] = group.countGroupedByYear
      names[group.uuid.uuidString] = group.name
    }
    do {
      try save(filename: "counts.json", data: counts, url: FileManager.sharedContainerURL)
      try save(filename: "names.json", data: names, url: FileManager.sharedContainerURL)
    } catch {
      print(error)
    }
  }
  
  static var current: WhatManager?
}

extension FileManager {
  static var documentDirectoryURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  static var sharedContainerURL: URL {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.your.domain")!
  }
}

func load<T: Decodable>(_ filename: String, url: URL = FileManager.documentDirectoryURL) throws -> T {
  let fileURL = url.appendingPathComponent(filename)
  let data = try Data(contentsOf: fileURL)
  let decoder = JSONDecoder()
  return try decoder.decode(T.self, from: data)
}

func save<T: Encodable>(filename: String, data: T, url: URL = FileManager.documentDirectoryURL) throws -> Void {
  let fileURL = url.appendingPathComponent(filename)
  let encoder = JSONEncoder()
  let encodeData = try encoder.encode(data)
  try encodeData.write(to: fileURL)
}

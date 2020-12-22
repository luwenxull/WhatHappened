//
//  WhatManager.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import Foundation
import WidgetKit

class WhatManager: ObservableObject {
  @Published var groups: [WhatGroup]
  @Published var loading: Bool = false
  
  init(_ groups: [WhatGroup]? = nil) {
    if groups != nil {
      self.groups = groups!
    } else {
      self.groups = []
      self.refresh()
    }
  }
  
  func refresh() -> Void {
    if UserDefaults.standard.string(forKey: "username") != nil {
      // 从数据库读取
      loading = true
      makeRequest(url: WhatRequestConfig.baseURL + "/group", config: jsonConfig(data: nil, method: "GET"), success: { data in
        DispatchQueue.main.async {
          self.loading = false
          self.groups = (try! JSONDecoder().decode(WhatServerResponse<[WhatGroup]>.self, from: data)).data!
        }
      }, fail: { _ in
        DispatchQueue.main.async {
          self.loading = false
        }
      })
    } else {
      // 从本地读取
      groups = (try? load("groups.json")) ?? []
    }
  }
  
  func addGroup(_ group: WhatGroup) {
    if UserDefaults.standard.string(forKey: "username") != nil {
      loading = true
      makeRequest(
        url: WhatRequestConfig.baseURL + "/group",
        config: jsonConfig(data: try? JSONEncoder().encode(group), method: "POST"),
        success: { _ in
          DispatchQueue.main.async {
            self.loading = false
            self.groups.append(group)
          }
        }
      )
    } else {
      groups.append(group)
      self.saveAsJson(updateCounts: true, updateNames: true)
    }
  }
  
  func removeGroup(_ group: WhatGroup) {
    if UserDefaults.standard.string(forKey: "username") != nil {
      loading = true
      makeRequest(
        url: WhatRequestConfig.baseURL + "/group/\(group.uuid.uuidString)",
        config: jsonConfig(data: nil, method: "DELETE"),
        success: { _ in
          DispatchQueue.main.async {
            self.loading = false
            self.groups = self.groups.filter { (_group) -> Bool in
              group !== _group
            }
          }
        }
      )
    } else {
      groups = groups.filter { (_group) -> Bool in
        group !== _group
      }
      self.saveAsJson(updateCounts: true, updateNames: true)
    }
  }
  
  func saveAsJson(updateCounts: Bool, updateNames: Bool) {
    do {
      try save(filename: "groups.json", data: groups)
    } catch {
      print(error)
    }
    // 年度数据
    var counts: [String: [Int: Int]] = [:]
    // id -> name的映射
    var names: [String: String] = [:]
    for group in groups {
      counts[group.uuid.uuidString] = group.countGroupedByYear
      names[group.uuid.uuidString] = group.name
    }
    do {
      if updateCounts {
        try save(filename: "counts.json", data: counts, url: FileManager.sharedContainerURL)
      }
      if updateNames {
        try save(filename: "names.json", data: names, url: FileManager.sharedContainerURL)
      }
    } catch {
      print(error)
    }
    
    WidgetCenter.shared.reloadAllTimelines()
  }
  
  static var current: WhatManager!
}

extension FileManager {
  static var documentDirectoryURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  static var sharedContainerURL: URL {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.wenxu.EmotionDiary")!
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

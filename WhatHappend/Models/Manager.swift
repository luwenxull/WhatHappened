//
//  WhatManager.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import Foundation
import WidgetKit

class WHManager: ObservableObject {
  @Published var events: [WHEvent]
  @Published var loading: Bool = false
  
  init(_ events: [WHEvent]? = nil) {
    if events != nil {
      self.events = events!
    } else {
      self.events = []
      self.refresh()
    }
  }
  
  func refresh() -> Void {
    if UserDefaults.standard.string(forKey: "username") != nil {
      // 从数据库读取
//      loading = true
//      makeRequest(url: WHRequestConfig.baseURL + "/group", config: jsonConfig(data: nil, method: "GET"), success: { data in
//        DispatchQueue.main.async {
//          self.loading = false
//          self.events = (try! JSONDecoder().decode(WhatServerResponse<[WHEvent]>.self, from: data)).data!
//        }
//      }, fail: { _ in
//        DispatchQueue.main.async {
//          self.loading = false
//        }
//      })
    } else {
      // 从本地读取
//      events = (try? load("events.json")) ?? []
      do {
        let _events: [WHEventCodable] = try load("events.json")
        events = _events.map({ e in
          WHEvent(from: e)
        })
      } catch {
        events = []
      }
      
    }
  }
  
  func addEvent(_ event: WHEvent) {
    if UserDefaults.standard.string(forKey: "username") != nil {
//      loading = true
//      makeRequest(
//        url: WHRequestConfig.baseURL + "/group",
//        config: jsonConfig(data: try? JSONEncoder().encode(event), method: "POST"),
//        success: { _ in
//          DispatchQueue.main.async {
//            self.loading = false
//            self.events.append(event)
//          }
//        }
//      )
    } else {
      events.append(event)
      self.saveAsJson()
    }
  }
  
  func removeEvent(_ event: WHEvent) {
    if UserDefaults.standard.string(forKey: "username") != nil {
//      loading = true
//      makeRequest(
//        url: WHRequestConfig.baseURL + "/group/\(event.uuid.uuidString)",
//        config: jsonConfig(data: nil, method: "DELETE"),
//        success: { _ in
//          DispatchQueue.main.async {
//            self.loading = false
//            self.events = self.events.filter { (_group) -> Bool in
//              event !== _group
//            }
//          }
//        }
//      )
    } else {
      events = events.filter { (e) -> Bool in
        event !== e
      }
      self.saveAsJson()
    }
  }
  
  func saveAsJson() {
    do {
      try save(filename: "events.json", data: events.map({ e in
        WHEventCodable(from: e)
      }))
    } catch {
      print(error)
    }
    
//    WidgetCenter.shared.reloadAllTimelines()
  }
  
  static var current: WHManager!
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

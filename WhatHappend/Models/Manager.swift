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
  
//  private var serverEvents: [WHEvent]
  
  init(_ events: [WHEvent]? = nil) {
    if events != nil {
      self.events = events!
    } else {
      let names: [String] = (try? load(filename: "events.json")) ?? []
      var _events: [WHEvent] = []
      for filename in names {
        if let event: WHEventCodable = try? load(filename: filename) {
          _events.append(WHEvent(from: event))
        }
      }
      self.events = _events
    }
    print(FileManager.sharedContainerURL)
  }
  
  // 同步到服务器
  func sync(
    success: @escaping () -> Void,
    fail: @escaping () -> Void
  ) {
    makeRequest(
      url: WHRequestConfig.baseURL + "/backup",
      config: jsonConfig(data: try? JSONEncoder().encode(
        WHManager.current.events.map({ e in
          WHEventCodable(from: e)
        })
      ), method: "POST"),
      success: { _ in
        success()
      },
      fail: { _ in
        fail()
      }
    )
  }
  
  // 从服务器恢复数据
  func restore(
    success: @escaping () -> Void,
    fail: @escaping () -> Void
  ) -> Void {
    makeRequest(
      url: WHRequestConfig.baseURL + "/event",
      config: jsonConfig(data: nil),
      success: {data in
        if let res = try? JSONDecoder().decode(WHServerResponse<[WHEventCodable]>.self, from: data) {
          let events: [WHEventCodable] = res.data!
          
          do {
            try save(filename: "events.json", data: events.map({ e in
              e.uuid.uuidString
            }))
          } catch {
            print(error)
          }
          
          for event in events {
            do {
              try save(filename: event.uuid.uuidString, data: event)
            } catch {
              print(error)
            }
          }
          
          DispatchQueue.main.async {
            self.events = events.map({ (e) in
              WHEvent(from: e)
            })
            success()
          }
          
        }
      },
      fail: {_ in
        fail()
      }
    )
  }
  
  // 清空本地数据
  func clear(removeFromServer: Bool = false) {
    for e in events {
      removeEvent(e, removeFromServer: removeFromServer)
    }
  }
  
  func addEvent(_ event: WHEvent) {
    events.append(event)
    saveEvent(event: event)
    if UserDefaults.standard.string(forKey: "username") != nil {
      makeRequest(
        url: WHRequestConfig.baseURL + "/event",
        config: jsonConfig(data: try? JSONEncoder().encode(WHEventCodable(from: event)), method: "POST")
      )
    }
  }
  
  // 移除事件
  func removeEvent(_ event: WHEvent, removeFromServer: Bool = false) {
    events = events.filter { (e) -> Bool in
      event !== e
    }
    saveEvent(event: event, removeEvent: true)
    if removeFromServer && UserDefaults.standard.string(forKey: "username") != nil {
      makeRequest(
        url: WHRequestConfig.baseURL + "/event/\(event.uuid.uuidString)",
        config: jsonConfig(data: nil, method: "DELETE")
      )
    }
  }
  
  func saveEvent(event: WHEvent, removeEvent: Bool = false) {
    do {
      try save(filename: "events.json", data: events.map({ e in
        e.uuid.uuidString
      }))
    } catch {
      print(error)
    }
    
    do {
      try save(filename: event.uuid.uuidString, data: WHEventCodable(from: event))
    } catch {
      print(error)
    }
    
    if removeEvent {
      do {
        try remove(filename: event.uuid.uuidString)
      } catch {
        print(error)
      }
    }
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

func load<T: Decodable>(filename: String, url: URL = FileManager.sharedContainerURL) throws -> T {
  let fileURL = url.appendingPathComponent(filename)
  let data = try Data(contentsOf: fileURL)
  let decoder = JSONDecoder()
  return try decoder.decode(T.self, from: data)
}

func save<T: Encodable>(filename: String, data: T, url: URL = FileManager.sharedContainerURL) throws -> Void {
  let fileURL = url.appendingPathComponent(filename)
  let encoder = JSONEncoder()
  let encodeData = try encoder.encode(data)
  try encodeData.write(to: fileURL)
}

func remove(filename: String, url: URL = FileManager.sharedContainerURL) throws -> Void {
  try FileManager.default.removeItem(at: url.appendingPathComponent(filename))
}

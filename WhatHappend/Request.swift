//
//  Request.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/16.
//

import Foundation

struct WHServerResponse<T: Decodable>: Decodable {
  let message: String
  let data: T?
}

struct WHRequestFail {
  let reason: String
  let response: WHServerResponse<String>?
}

struct WHRequestConfig {
  static let baseURL = "https://wxxfj.xyz:3000"
}

func jsonConfig(data: Data?, method: String = "GET") -> (inout URLRequest) -> Void {
  return {(request: inout URLRequest) -> Void in
    request.httpMethod = method
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    if let username = UserDefaults.standard.string(forKey: "username") {
      request.addValue(username, forHTTPHeaderField: "username")
    }
    
    request.httpBody = data
  }
}

func makeRequest(
  url: String,
  config: (inout URLRequest) -> Void,
  success: ((Data) -> Void)? = nil,
  fail: ((WHRequestFail) -> Void)? = nil
) {
  let url = URL(string: url)!
  var request = URLRequest(url: url)
  
  config(&request)
  
  URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data else {                                              // check for fundamental networking error
      if let fail = fail {
        fail(WHRequestFail(reason: "No response data", response: nil))
      }
      return
    }
    
    guard error == nil else {
      if let fail = fail {
        fail(WHRequestFail(reason: error!.localizedDescription, response: nil))
      }
      return
    }
    
    guard let response = response as? HTTPURLResponse else {
      if let fail = fail {
        fail(WHRequestFail(reason: "Unkown response", response: nil))
      }
      return
    }
    
    guard (200 ... 299) ~= response.statusCode else { // check for http errors
      if let fail = fail {
        fail(WHRequestFail(reason: "Not a success status code", response: try? JSONDecoder().decode(WHServerResponse<String>.self, from: data)))
      }
      return
    }
    
    if success != nil {
      success!(data)
    }
    
  }.resume()
}



//
//  Request.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/16.
//

import Foundation

func postConfig(json: Any) -> (inout URLRequest) -> Void {
  return {(request: inout URLRequest) -> Void in
    request.httpMethod = "POST"
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.httpBody = jsonData
  }
}

func makeRequest(url: String, config: (inout URLRequest) -> Void, callback: @escaping (Any?) -> Void) {
  let url = URL(string: url)!
  var request = URLRequest(url: url)
  
  config(&request)
  
  URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
      print(error?.localizedDescription ?? "No data")
      return
    }
    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
    callback(responseJSON)
  }.resume()
  
}



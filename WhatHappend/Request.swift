//
//  Request.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/16.
//

import Foundation

struct WhatServerResponse: Decodable {
  let message: String
}

struct WhatRequestFail {
  let reason: String
  let response: WhatServerResponse?
}

func postConfig(json: Any) -> (inout URLRequest) -> Void {
  return {(request: inout URLRequest) -> Void in
    request.httpMethod = "POST"
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.httpBody = jsonData
  }
}

func makeRequest(
  url: String,
  config: (inout URLRequest) -> Void,
  success: ((Data) -> Void)?,
  fail: ((WhatRequestFail) -> Void)?
) {
  let url = URL(string: url)!
  var request = URLRequest(url: url)
  
  config(&request)
  
  URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data else {                                              // check for fundamental networking error
      if let fail = fail {
        fail(WhatRequestFail(reason: "No response data", response: nil))
      }
      return
    }
    
    guard error == nil else {
      if let fail = fail {
        fail(WhatRequestFail(reason: error!.localizedDescription, response: nil))
      }
      return
    }
    
    guard let response = response as? HTTPURLResponse else {
      if let fail = fail {
        fail(WhatRequestFail(reason: "Unkown response", response: nil))
      }
      return
    }
    
    
    guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
      if let fail = fail {
        fail(WhatRequestFail(reason: "Not a success status code", response: try? JSONDecoder().decode(WhatServerResponse.self, from: data)))
      }
      return
    }
    
    if success != nil {
      success!(data)
    }
    
  }.resume()
}



//
//  File.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/23.
//

import Foundation
import SwiftUI

typealias WHValidator<T> = (T) -> String?

class WHChecker<T> {
  var key: String
  var binding: Binding<T>
  var validators: [WHValidator<T>]
  
  func check(collector: inout [String: String]) -> Bool {
    for validator in validators {
      let result = validator(binding.wrappedValue)
      if result != nil {
        collector[key] = result
        return false
      }
    }
    return true
  }
  
  init(key: String, binding: Binding<T>, validators: [WHValidator<T>]) {
    self.key = key
    self.binding = binding
    self.validators = validators
  }
}

func requiredChecker(v: String) -> String? {
  v.isEmpty ? "必填" : nil
}

func IntChecker(v: String) -> String? {
  if Int(v) != nil {
    return nil
  } else {
    return "非正确整数"
  }
}

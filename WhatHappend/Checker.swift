//
//  File.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/23.
//

import Foundation
import SwiftUI

typealias WHValidator<T> = (T) -> String?

class WHChecker<T>: ObservableObject {
  var binding: Binding<T>!
  var value: T
  var validators: [WHValidator<T>]
  @Published var error: String?
  
  func check() -> Bool {
    for validator in validators {
      let result = validator(binding.wrappedValue)
      if result != nil {
        error = result
        return false
      }
    }
    error = nil
    return true
  }
  
  
  
  init(value: T, validators: [WHValidator<T>]) {
    self.value = value
    self.validators = validators
    self.binding = Binding(get: {[self] in self.value}, set: {[self] v in
      self.value = v
    })
  }
  
}

func requiredChecker(v: String) -> String? {
  v.isEmpty ? "必填" : nil
}

func IntChecker(v: String) -> String? {
  if Int(v) != nil {
    return nil
  } else {
    return "不是合理的数字"
  }
}

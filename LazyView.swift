//
//  LazyView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/31.
//

import SwiftUI

struct LazyView<Content: View>: View {
  var content: () -> Content
  @State var shouldDisplay: Bool = false
  var body: some View {
    if shouldDisplay {
      content()
    } else {
      Text("")
        .onAppear(perform: {
          shouldDisplay = true
        })
    }
  }
}

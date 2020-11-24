//
//  TimesView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/25.
//

import SwiftUI

struct TimesView: View {
  let tag: WhatTag
  var body: some View {
    VStack {
      List {
        ForEach(tag.times, id: \.self) { time in
          Text(DateFormatter.localizedString(from: time, dateStyle: .medium, timeStyle: .short))
        }
      }
    }
    .navigationBarTitle(tag.name)
    .navigationBarTitleDisplayMode(.inline)
  }
}

//struct TimesView_Previews: PreviewProvider {
//  static var previews: some View {
//    TimesView(times: [Date()])
//  }
//}

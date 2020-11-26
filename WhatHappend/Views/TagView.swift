//
//  TagView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

struct TagView: View {
  let tag: WhatTag
  
  var longPress: some Gesture {
    LongPressGesture(minimumDuration: 1)
      .onEnded { finished in
        if finished {
          print("finished")
        }
      }
  }
  
  
  var body: some View {
    return HStack {
      getImage()
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
        .gesture(longPress)
      Spacer()
      Text(tag.name)
        .padding()
    }
//    .padding()
  }
  
  func getImage() -> Image {
    tag.emotion == .happy ? Image("happy") : Image("unhappy")
  }
}

struct TagView_Previews: PreviewProvider {
  static var previews: some View {
    TagView(tag: WhatTag(name: "Test", emotion: .happy, times: [Date()]))
  }
}
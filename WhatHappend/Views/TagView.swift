//
//  TagView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

struct TagView: View {
  let tag: WhatTag
  var body: some View {
    HStack{
      getImage()
        .scaledToFit()
        .frame(width: 50, height: 50, alignment: .center)
      Spacer()
      Text(tag.name)
        .padding()
    }
    .padding()
  }
  
  func getImage() -> some View {
    tag.emotion == WhatEmotion.happy ? Image("happy") : Image("unhappy")
  }
}

struct TagView_Previews: PreviewProvider {
  static var previews: some View {
    TagView(tag: WhatTag(name: "Test", emotion: .happy, times: [Date()]))
  }
}

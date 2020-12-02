//
//  GroupView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

struct GroupView: View {
  let group: WhatGroup
  
  var body: some View {
    return
      HStack {
        getImage()
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
        Spacer()
        Text(group.name)
      }
      .padding()
    
  }
  
  func getImage() -> Image {
    group.emotion == .happy ? Image("happy") : Image("unhappy")
  }
}

struct GroupView_Previews: PreviewProvider {
  static var previews: some View {
    GroupView(group: WhatGroup(name: "Test", emotion: .happy, times: [WhatTime()]))
  }
}

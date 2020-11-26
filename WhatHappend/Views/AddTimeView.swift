//
//  AddTimeView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/26.
//

import SwiftUI

struct AddTimeView: View {
  @State var hasError: Bool = false
  @State var whatTime: WhatTime = WhatTime()
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var tag: WhatTag
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Spacer()
        Button(action: {
          tag.addRecord(whatTime)
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("ADD")
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                  .stroke(Color.accentColor, lineWidth: 2)
            )
        })
      }
      Divider()
      DatePicker("Date", selection: $whatTime.date)
      TextField("Description", text: $whatTime.description)
      Spacer()
    }
    .padding()
  }
}

struct AddTimeView_Previews: PreviewProvider {
  static var previews: some View {
    AddTimeView(tag: WhatTag(name: "Test", emotion: .happy, times: [WhatTime()]))
  }
}

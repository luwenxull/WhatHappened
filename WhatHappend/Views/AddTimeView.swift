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
      
      DatePicker("Date", selection: $whatTime.date)
      TextField("Description", text: $whatTime.description)
      Spacer()
      HStack {
        Spacer()
        Circle()
          .frame(width: 80, height: 80, alignment: .center)
          .foregroundColor(.red)
          .opacity(0.6)
          .shadow(radius: 4)
          .overlay(Button(action: {            presentationMode.wrappedValue.dismiss()
          }, label: {
            Image(systemName: "xmark")
              .font(.system(size: 40))
              .foregroundColor(.white)
          }))
        Spacer()
        Circle()
          .frame(width: 80, height: 80, alignment: .center)
          .foregroundColor(.green)
          .opacity(0.6)
          .shadow(radius: 4)
          .overlay(Button(action: {
            tag.addRecord(whatTime)
            presentationMode.wrappedValue.dismiss()
          }, label: {
            Image(systemName: "checkmark")
              .font(.system(size: 40))
              .foregroundColor(.white)
          }))
        Spacer()
      }
    }
    .padding()
  }
}

struct AddTimeView_Previews: PreviewProvider {
  static var previews: some View {
    AddTimeView(tag: WhatTag(name: "Test", emotion: .happy, times: [WhatTime()]))
  }
}

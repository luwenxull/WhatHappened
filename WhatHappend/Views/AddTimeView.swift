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
  @ObservedObject var group: WHEvent
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("Cancel")
        })
        
        Spacer()
        
        Button(action: {
          group.addRecord(whatTime)
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("Confirm")
        })
      }
      .padding()
      
      Divider()
      
      VStack {
        DatePicker("Date", selection: $whatTime.date)
        TextField("Description(Optional)", text: $whatTime.description)
      }.padding()

      Spacer()
    }
  }
}

struct AddTimeView_Previews: PreviewProvider {
  static var previews: some View {
    AddTimeView(group: WHEvent(name: "Test", emotion: .happy, times: [WhatTime()]))
  }
}

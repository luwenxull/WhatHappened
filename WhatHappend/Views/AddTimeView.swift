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
  @ObservedObject var group: WhatGroup
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Add record").padding(.vertical).font(.title2)
      Divider()
      
      DatePicker("Date", selection: $whatTime.date)
      TextField("Description(Optional)", text: $whatTime.description)
      Spacer()
      HStack {
        Spacer()
        
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("Cancel")
        })
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2)
        )
        
        Spacer()
        
        Button(action: {
          group.addRecord(whatTime)
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("Confirm")
        })
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2)
        )
        
        Spacer()
      }
    }
    .padding()
  }
}

struct AddTimeView_Previews: PreviewProvider {
  static var previews: some View {
    AddTimeView(group: WhatGroup(name: "Test", emotion: .happy, times: [WhatTime()]))
  }
}

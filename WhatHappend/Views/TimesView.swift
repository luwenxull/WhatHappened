//
//  TimesView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/25.
//

import SwiftUI

struct TimesView: View {
  @ObservedObject var group: WhatGroup
  @State var isPressing: Bool = false
  @State var showSheet: Bool = false
  
  var body: some View {
    VStack {
      List {
        ForEach(group.times, id: \.self) { time in
          VStack(alignment: .leading) {
            Text(DateFormatter.localizedString(from: time.date, dateStyle: .medium, timeStyle: .short))
            if !time.description.isEmpty {
              Text(time.description)
                .foregroundColor(.gray)
                .font(.system(size: 12))
                .padding(.vertical, 4)
            }
          }
        }
        .onDelete(perform: { indexSet in
          for i in indexSet {
            group.removeRecord(i)
          }
        })
      }
      Spacer()
      HStack {
        Spacer()
        
        Button(action: {
          group.addRecord(WhatTime())
        }, label: {
          Text("ADD QUICKLY")
        })
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2)
        )
        
        Spacer()
        
        Button(action: {
          showSheet = true
        }, label: {
          Text("ADD")
        })
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2)
        )
        
        Spacer()
      }
    }
    .navigationBarTitle(group.name)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar(content: {
      ToolbarItem(placement: ToolbarItemPlacement.automatic) {
        NavigationLink(
          destination: StatView(group: group),
          label: {
            Text("STATISTIC")
          })
      }
    })
    .sheet(isPresented: $showSheet, content: {
      AddTimeView(group: group)
    })
  }
}

struct TimesView_Previews: PreviewProvider {
  static var previews: some View {
    TimesView(group: WhatGroup(name: "Test", emotion: .happy, times: [WhatTime()]))
  }
}

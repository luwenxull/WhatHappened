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
  
  var content: some View {
    if group.times.count > 0 {
      return AnyView(
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
      )
    } else {
      return AnyView(
        VStack {
          Image("empty")
          Text("No record, please add fisrt")
            .foregroundColor(.gray)
            .font(.footnote)
        }
      )
    }
  }
  
  var body: some View {
    VStack {
      content
      
      Spacer()
      HStack {
        Spacer()
        
        Button(action: {
          group.addRecord(WhatTime())
        }, label: {
          Text("Add quickly")
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
          Text("Add")
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
          label: { () -> AnyView in
            if (group.times.count > 0) {
              return AnyView(Text("Statistic"))
            } else {
              return AnyView(EmptyView())
            }
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

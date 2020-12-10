//
//  ContentView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var whatManager: WhatManager
  @State var sheetIsPresented: Bool = false
  
  var content: some View {
    if whatManager.groups.count > 0 {
      return AnyView(List {
        ForEach(whatManager.groups) {group in
          NavigationLink(destination: TimesView(group: group)) {
            GroupView(group: group)
          }
        }
      })
    } else {
      return AnyView(
        VStack {
          Image("empty")
          Text("No event group, please add fisrt")
            .foregroundColor(.gray)
            .font(.footnote)
        }
      )
    }
  }
  
  var body: some View {
    NavigationView {
      content
      .navigationBarTitle("Emotion Diary")
      .toolbar(content: {
        ToolbarItem(placement: ToolbarItemPlacement.automatic, content: {
          Button(action: {
            sheetIsPresented = true
          }, label: {
            Text("Add event group")
          })
        })
      })
      .sheet(isPresented: $sheetIsPresented, content: {
        ModifyGroupView()
      })
    }
    .listStyle(PlainListStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(WhatManager([
      WhatGroup(name: "上下班又下雨了", emotion: .unhappy, times: [WhatTime()]),
      WhatGroup(name: "打球", emotion: .happy, times: [WhatTime()]),
    ]))
    ContentView()
      .environment(\.colorScheme, .dark)
      .environmentObject(WhatManager([]))
  }
}

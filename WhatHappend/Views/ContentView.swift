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
  var body: some View {
    NavigationView {
      List {
        ForEach(whatManager.tags) {tag in
          NavigationLink(destination: TimesView(tag: tag)) {
            TagView(tag: tag)
          }
        }
      }
      .navigationBarTitle("Emotion Diary")
      .toolbar(content: {
        ToolbarItem(placement: ToolbarItemPlacement.automatic, content: {
          Button(action: {
            sheetIsPresented = true
          }, label: {
            Text("Add Group")
          })
        })
      })
      .sheet(isPresented: $sheetIsPresented, content: {
        AddTagView()
      })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(WhatManager(tags: [
      WhatTag(name: "上下班又下雨了", emotion: .unhappy, times: [WhatTime()]),
      WhatTag(name: "打球", emotion: .happy, times: [WhatTime()]),
    ]))
    ContentView()
      .environment(\.colorScheme, .dark)
      .environmentObject(WhatManager(tags: [
        WhatTag(name: "今天又下雨了", emotion: .unhappy, times: [WhatTime()]),
        WhatTag(name: "今天打球了", emotion: .happy, times: [WhatTime()]),
      ]))
  }
}

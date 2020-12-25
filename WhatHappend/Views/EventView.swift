//
//  GroupView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

struct EventView: View {
  @ObservedObject var event: WHEvent
  @State var sheetIsPresented: Bool = false
  @State var actionSheetIsPresented: Bool = false
  @EnvironmentObject var manager: WHManager
  
  var body: some View {
    HStack {
      Text(event.name)
    }
    .padding()
    .contextMenu(menuItems: {
      Button(action: {
        sheetIsPresented = true
      }, label: {
        HStack {
          Image(systemName: "pencil.circle")
          Text("修改")
        }
      })
      Button(action: {
        actionSheetIsPresented = true
      }, label: {
        HStack {
          Image(systemName: "trash.circle")
          Text("删除")
        }
      })
    })
    .sheet(isPresented: $sheetIsPresented, content: {
      ModifyEventView(event: event)
    })
    .actionSheet(isPresented: $actionSheetIsPresented, content: {
      ActionSheet(
        title: Text("删除事件同时会删除事件下的所有记录，是否继续？"),
        buttons: [
          .cancel(Text("取消")),
          .destructive(Text("确认"), action: {
            manager.removeEvent(event)
          })
        ])
    })
  }
}

struct GroupView_Previews: PreviewProvider {
  static var previews: some View {
    EventView(event: WHEvent(name: "Test"))
  }
}

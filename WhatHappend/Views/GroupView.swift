//
//  GroupView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

struct GroupView: View {
  @ObservedObject var group: WhatGroup
  @State var sheetIsPresented: Bool = false
  @State var actionSheetIsPresented: Bool = false
  @EnvironmentObject var whatManager: WhatManager
  
  var body: some View {
    HStack {
      getImage()
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
      Spacer()
      Text(group.name)
    }
    .padding()
    .contextMenu(menuItems: {
      Button(action: {
        sheetIsPresented = true
      }, label: {
        HStack {
          Image(systemName: "pencil.circle")
          Text("Modify")
        }
      })
      Button(action: {
        actionSheetIsPresented = true
      }, label: {
        HStack {
          Image(systemName: "trash.circle")
          Text("Delete")
        }
      })
    })
    .sheet(isPresented: $sheetIsPresented, content: {
      ModifyGroupView(group: group)
    })
    .actionSheet(isPresented: $actionSheetIsPresented, content: {
      ActionSheet(
        title: Text("Delete event group will delete all records in this group!"),
        buttons: [
          .cancel(Text("Cancel")),
          .destructive(Text("Confirm"), action: {
            whatManager.removeGroup(group)
          })
        ])
    })
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

//
//  ProfileView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2021/1/3.
//

import SwiftUI

struct PrifileLineView: View {
  let image: String
  let text: String
  var body: some View {
    HStack {
      Text(text)
//        .foregroundColor(.gray)
      Spacer()
      Image(image)
        .resizable()
        .scaledToFit()
        .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

    }
    .padding(8)
  }
}

struct ProfileView: View {
  @State var actionSheetIsPresented: Bool = false
  var body: some View {
    VStack {
      List {
        PrifileLineView(image: "Cloud", text: "立即同步到远端")
        PrifileLineView(image: "Sync", text: "从远端恢复")
        PrifileLineView(image: "Clear", text: "移除所有数据")
          .onTapGesture {
            actionSheetIsPresented = true
          }
      }
      .actionSheet(isPresented: $actionSheetIsPresented, content: {
        ActionSheet(
          title: Text("此操作将会同时清除本地和远端的所有数据且不可恢复，是否继续？"),
          buttons: [
            .cancel(Text("取消")),
            .destructive(Text("确认"), action: {

            })
          ])
      })
      
      Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
        Text("退出登录")
      })
    }

  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}

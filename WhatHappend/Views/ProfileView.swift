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
  @State var alertIsPresented: Bool = false
  @State var alertText: String = ""
  @Environment(\.presentationMode) var presentationMode
  var body: some View {
    VStack {
      List {
        PrifileLineView(image: "Cloud", text: "同步到远端")
          .onTapGesture {
            WHManager.current.sync(success: {
              alertText = "同步成功"
              alertIsPresented = true
            }, fail: {
              alertText = "同步失败"
              alertIsPresented = true
            })
          }
        PrifileLineView(image: "Sync", text: "同步到本地")
          .onTapGesture {
            WHManager.current.restore(success: {
              alertText = "同步成功"
              alertIsPresented = true
            }, fail: {
              alertText = "同步失败"
              alertIsPresented = true
            })
          }
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
      .listStyle(PlainListStyle())
      .alert(isPresented: $alertIsPresented, content: {
        Alert(title: Text(alertText))
      })
      Button(action: {
        UserDefaults.standard.set(nil, forKey: "username")
        // 仅仅移除本地，不移除服务器数据
        WHManager.current.clear()
        presentationMode.wrappedValue.dismiss()
      }, label: {
        Text("退出登录")
      })
    }
    .navigationBarTitle(Text(UserDefaults.standard.string(forKey: "username") ?? ""))

  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}

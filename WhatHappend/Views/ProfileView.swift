//
//  ProfileView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2021/1/3.
//

import SwiftUI

struct ProfileLineView: View {
  let image: String
  let text: String
  var body: some View {
    HStack {
      Text(text)
        .font(.system(size: 14))
      Spacer()
      Image(image)
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      
    }
    //    .padding(4)
  }
}

struct ProfileView: View {
  @State var actionSheetIsPresented: Bool = false
  @State var alertText: String? = nil {
    didSet {
      if alertText != nil {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) {_ in
          alertText = nil
        }
      }
    }
  }
  @State var pending: Bool = false
  @State var timer: Timer?
  
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    NotificationView(text: alertText) {
      ZStack {
        VStack {
          List {
            Section(header: Text("数据管理")) {
              ProfileLineView(image: "Cloud", text: "备份到远端")
                .onTapGesture {
                  pending = true
                  WHManager.current.sync(success: {
                    alertText = "备份成功"
                    pending = false
                  }, fail: {
                    alertText = "备份失败，请稍后再试"
                    pending = false
                  })
                }
              ProfileLineView(image: "Sync", text: "恢复到本地")
                .onTapGesture {
                  pending = true
                  WHManager.current.restore(success: {
                    alertText = "恢复成功"
                    pending = false
                  }, fail: {
                    alertText = "恢复失败，请稍后再试"
                    pending = false
                  })
                }
              ProfileLineView(image: "Clear", text: "移除所有数据")
                .onTapGesture {
                  actionSheetIsPresented = true
                }
            }
            
          }
//          .actionSheet(isPresented: $actionSheetIsPresented, content: {
//            ActionSheet(
//              title: Text("此操作将会同时清除本地和远端的所有数据且不可恢复，是否继续？"),
//              buttons: [
//                .cancel(Text("取消")),
//                .destructive(Text("确认"), action: {
//
//                })
//              ])
//          })
          .listStyle(GroupedListStyle())
//          .alert(isPresented: $alertIsPresented, content: {
//            Alert(title: Text(alertText))
//          })
          Button(action: {
            UserDefaults.standard.set(nil, forKey: "username")
            // 仅仅移除本地，不移除服务器数据
            WHManager.current.clear()
            presentationMode.wrappedValue.dismiss()
          }, label: {
            Text("退出登录")
          })
        }
        
        // pending遮罩
        if pending {
          Color.black.opacity(0.33)
            .ignoresSafeArea(.all)
            .overlay(
              ProgressView()
            )
        }
      }
    }
    .navigationTitle(UserDefaults.standard.string(forKey: "username") ?? "")
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}

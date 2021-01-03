//
//  ContentView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI
import Combine

struct ContentView: View {
  @EnvironmentObject var manager: WHManager
  @State var sheetIsPresented: Bool = false
  @State var user: String? = UserDefaults.standard.string(forKey: "username")
  
  var content: some View {
    if manager.loading {
      return AnyView(ProgressView())
    }
    
    if manager.events.count > 0 {
      return AnyView(
        ScrollView {
          ForEach(manager.events) {event in
            EventView(event: event)
              .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
          }
        }
      )
    } else {
      return AnyView(
        VStack {
          Image("empty")
          Text("还没有事件，先添加一个吧！")
            .foregroundColor(.gray)
            .font(.footnote)
        }
      )
    }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        NavigationLink(
          destination: LazyView {
            ModifyEventView()
          },
          isActive: $sheetIsPresented,
          label: { EmptyView() }
        )
        content
          .navigationBarTitle("我的一天")
          .toolbar(content: {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading, content: {
              if (user == nil) {
                NavigationLink(
                  destination: LoginView(),
                  label: {
                    Image(systemName: "person.circle")
                  })
              }
              if (user != nil) {
                Menu(content: {
                  Button(action: {
                    UserDefaults.standard.removeObject(forKey: "username")
                    user = nil
                    manager.refresh()
                  }, label: {
                    Text("退出登录")
                  })
                }, label: {
                  Text(String(user!.first!).capitalized)
                    .padding(4)
                    .overlay(
                      Circle()
                        .stroke(Color.accentColor, lineWidth: 2)
                    )
                })
              }
            })
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing, content: {
              Button(action: {
                sheetIsPresented = true
              }, label: {
                Text("添加事件")
              })
            })
          })
          .onAppear {
            if user != UserDefaults.standard.string(forKey: "username") {
              user = UserDefaults.standard.string(forKey: "username")
            }
          }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(WHManager([
      WHEvent(name: "上下班又下雨了"),
      WHEvent(name: "Test", asDailyTarget: true, targetCount: 5, targetUnit: "次", records: [:])
    ]))
    ContentView()
      .environment(\.colorScheme, .dark)
      .environmentObject(WHManager([
        WHEvent(name: "上下班又下雨了"),
        WHEvent(name: "Test", asDailyTarget: true, targetCount: 5, targetUnit: "次", records: [:])
      ]))
  }
}

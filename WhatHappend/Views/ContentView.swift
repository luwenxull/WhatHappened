//
//  ContentView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var manager: WHManager
  @State var sheetIsPresented: Bool = false
  @State var user: String? = UserDefaults.standard.string(forKey: "username")
  
  var content: some View {
    if manager.loading {
      return AnyView(ProgressView())
    }
    
    if manager.events.count > 0 {
      return AnyView(List {
        ForEach(manager.events) {event in
          NavigationLink(destination: Text("TODo")) {
            EventView(event: event)
          }
        }
      })
    } else {
      return AnyView(
        VStack {
          Image("empty")
          Text("No event, please add fisrt")
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
                  Text("Logout")
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
              Text("Add event")
            })
          })
        })
        .sheet(isPresented: $sheetIsPresented, content: {
          ModifyEventView()
        })
        .onAppear {
          if user != UserDefaults.standard.string(forKey: "username") {
            user = UserDefaults.standard.string(forKey: "username")
          }
        }
    }
    .listStyle(PlainListStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(WHManager([
      WHEvent(name: "上下班又下雨了", emotion: .unhappy, times: [WhatTime()]),
      WHEvent(name: "打球", emotion: .happy, times: [WhatTime()]),
    ]))
    ContentView()
      .environment(\.colorScheme, .dark)
      .environmentObject(WHManager([]))
  }
}

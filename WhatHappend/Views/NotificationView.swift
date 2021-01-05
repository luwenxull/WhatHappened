//
//  NotificationView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2021/1/5.
//

import SwiftUI

struct NotificationView<Content: View>: View {
  var text: String?
  var content: () -> Content
  var body: some View {
    ZStack(alignment: .top) {
      content()
//      if text != nil {
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.green)
          .overlay(
            HStack {
              Text(text ?? "")
              Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal)
          )
          .frame(height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          .padding(.horizontal)
          .offset(x: 0, y: text == nil ? -60 : 40)
          .opacity(text == nil ? 0 : 1)
          .animation(.spring())
//          .transition(.move(edge: .top))
          .edgesIgnoringSafeArea(.top)
//      }
    }
    .navigationBarBackButtonHidden(text != nil)
  }
}

struct NotificationView_Previews: PreviewProvider {
  static var previews: some View {
    NotificationView( text: "hello world", content: {
      Text("bg")
    })
  }
}

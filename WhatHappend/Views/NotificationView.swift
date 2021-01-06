//
//  NotificationView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2021/1/5.
//

import SwiftUI

struct NotificationBarView: View {
  @EnvironmentObject var controller: NotificationBarController
  
  var body: some View {
    RoundedRectangle(cornerRadius: 16, style: .continuous)
      .fill(Color.accentColor)
      .overlay(
        HStack {
          Text(controller.binding.wrappedValue ?? "")
          Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal)
      )
      .frame(height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
      .padding(.horizontal)
      .offset(x: 0, y: controller.binding.wrappedValue == nil ? -60 : 40)
      .opacity(controller.binding.wrappedValue == nil ? 0 : 1)
      .animation(.spring())
      .edgesIgnoringSafeArea(.top)
  }
}

class NotificationBarController: ObservableObject {
  static var current: NotificationBarController!
  @Published var binding: Binding<String?>
  var timer: Timer?
  
  init(binding: Binding<String?> = .constant(nil)) {
    self.binding = binding
  }
}

extension View {
  func notifyBar(text: Binding<String?>) -> some View {
    NotificationBarController.current.binding = text
    
    if text.wrappedValue != nil {
      if let timer = NotificationBarController.current.timer {
        timer.invalidate()
      }
      NotificationBarController.current.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { _ in
        text.wrappedValue = nil
      })
    }
    
    return self
  }
}

struct NotificationBarView_Previews: PreviewProvider {
  static var previews: some View {
    NotificationBarView()
      .environmentObject(NotificationBarController(binding: .constant("hello world")))
  }
}

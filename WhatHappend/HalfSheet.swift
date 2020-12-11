//
//  HalfSheet.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/11.
//

import SwiftUI

struct HalfSheetView<Content: View>: View {
  var presented: HSBinding
  var content: () -> Content
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    ZStack {
      if presented.wrappedValue {
        Color.gray
          .opacity(0.2)
          .animation(.easeIn(duration: 0.2))
          .onTapGesture {
            presented.wrappedValue = false
          }
      }
      
      VStack {
        Spacer()
        VStack {
          HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 6)
              .frame(width: 80, height: 6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              .foregroundColor(.gray)
              .padding(8)
            
            Spacer()
          }
          content()
          Spacer()
        }
        .frame(height: 260)
        .background(colorScheme == .light ? Color.white : Color.black)
        .cornerRadius(25)
        .animation(.easeIn(duration: 0.2))
        .offset(x: 0, y: presented.wrappedValue ? 0 : 260)
      }
    }
    .ignoresSafeArea(.container, edges: .all)
    //    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
  }
}

class HSController: ObservableObject {
  var binding: HSBinding?
  @Published var content: (() -> AnyView)?
  @Published var refreshID: UUID = UUID()
  static var current: HSController!
}

@propertyWrapper class HSBinding {
  var value: Bool = false
  
  var wrappedValue: Bool {
    get {
      value
    }
    
    set {
      value = newValue
      HSController.current.refreshID = UUID()
    }
  }
  
  var projectedValue: HSBinding {
    self
  }
  
  
  init(value: Bool) {
    print("new HSBinding")
    self.value = value
  }
}

extension View {
  func halfSheet<Content: View>(isPresented: HSBinding, content: @escaping () -> Content) -> some View {
    HSController.current.content = { AnyView(content()) }
    HSController.current.binding = isPresented
    return self.onDisappear(perform: {
      HSController.current.content = nil
      HSController.current.binding = nil
    })
  }
}

struct HalfSheetView_Previews: PreviewProvider {
  static var previews: some View {
    HalfSheetView(presented: HSBinding(value: true), content: {Text("hello world")})
  }
}


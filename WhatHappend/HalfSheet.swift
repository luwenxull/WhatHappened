//
//  HalfSheet.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/11.
//

import SwiftUI

struct HalfSheetView<Content: View>: View {
  var presented: Binding<Bool>
  var content: () -> Content
  let id: UUID = UUID()
  var body: some View {
    return ZStack(alignment: .bottom) {
      Color.black
        .opacity(presented.wrappedValue ? 0.3 : 0)
        .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
        .onTapGesture {
          presented.wrappedValue = false
        }
      VStack {
        HStack {
          Spacer()
          RoundedRectangle(cornerRadius: 6)
            .frame(width: 80, height: 6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .foregroundColor(.gray)
            .padding()
          
          Spacer()
        }
        content()
        Spacer()
      }
      .frame(height: 260)
      .background(Color.white)
      .cornerRadius(25)
      .animation(.easeIn)
      .offset(x: 0, y: presented.wrappedValue ? 0 : 260)
    }
    .ignoresSafeArea(.container, edges: .all)
  }
}

class HSController: ObservableObject {
  @Published var view: HalfSheetView<AnyView>?
  static var current: HSController!
}

@propertyWrapper struct HSBinding {
  var value: Bool
  var wrappedValue: Bool {
    get {
      value
    }
    set {
      value = newValue
    }
  }
}

extension View {
  func halfSheet<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
    HSController.current.view = HalfSheetView(presented: isPresented, content: { AnyView(content()) })
    return self.onDisappear(perform: {
      HSController.current.view = nil
    })
  }
}

struct HalfSheetView_Previews: PreviewProvider {
  static var previews: some View {
    HalfSheetView(presented: .constant(true), content: {Text("hello world")})
  }
}


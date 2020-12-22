//
//  AddGroupView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/1.
//

import SwiftUI

struct ModifyGroupView: View {
  var group: WhatGroup?
  @State var name: String = ""
  @State var emotion: WhatEmotion = .happy
  @State var alertIsPresented: Bool = false
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var whatManager: WhatManager
  
  struct ImageStyle: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
      content
        .scaledToFit()
        .frame(width: size, height: size)
    }
  }
  
  func withCircle(
    image: Image,
    with: Bool,
    size: CGFloat
  ) -> some View {
    if with {
      return
        image
        .resizable()
        .modifier(ImageStyle(size: size - 2))
        .scaleEffect(1)
        .opacity(1)
        .animation(.spring())
      
    } else {
      return
        image
        .resizable()
        .modifier(ImageStyle(size: size))
        .scaleEffect(0.6)
        .opacity(0.6)
        .animation(.spring())
    }
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("Cancel")
        })
        
        Spacer()
        
        Button(action: {
          if (name.isEmpty) {
            alertIsPresented = true
          } else {
            if self.group == nil {
              whatManager.addGroup(WhatGroup(name: name, emotion: emotion, times: []))
            } else {
              group!.updateFrom(WhatGroupForUpate(name: name, emotion: emotion))
            }
            presentationMode.wrappedValue.dismiss()
          }
        }, label: {
          Text("Confirm")
        })
        .alert(isPresented: $alertIsPresented, content: {
          Alert(title: Text("Event name can't be empty!"))
        })
      }
      .padding()
      
      Divider()

      VStack {
        
        TextField("Event name", text: $name)
        HStack {
          Text("Choose emotion")
          Spacer()
          Group {
            withCircle(image: Image("happy"), with: emotion == .happy, size: 40)
              .onTapGesture {
                emotion = .happy
              }
            withCircle(image: Image("unhappy"), with: emotion == .unhappy, size: 40)
              .onTapGesture {
                emotion = .unhappy
              }
          }
        }
      }
      .padding()
      
      Spacer()
    }
    .onAppear(perform: {
      if group != nil {
        name = group!.name
        emotion = group!.emotion
      }
    })
  }
}

struct AddGroupView_Previews: PreviewProvider {
  static var previews: some View {
    ModifyGroupView()
  }
}

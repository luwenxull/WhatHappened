//
//  AddGroupView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/1.
//

import SwiftUI

struct AddGroupView: View {
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
      return AnyView(
        image
          .resizable()
          .modifier(ImageStyle(size: size - 2))
          .scaleEffect(1)
          .opacity(1)
          .animation(.spring())
      )
    } else {
      return AnyView(
        image
          .resizable()
          .modifier(ImageStyle(size: size))
          .scaleEffect(0.6)
          .opacity(0.6)
          .animation(.spring())
        
      )
    }
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Add Group").padding(.vertical).font(.title2)
      Divider()
      TextField("Group Name", text: $name)
      HStack {
        Text("Choose Emotion")
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
      
      Spacer()
      
      HStack {
        Spacer()
        
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("CANCEL")
        })
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2)
        )
        
        Spacer()
        
        Button(action: {
          if (name.isEmpty) {
            alertIsPresented = true
          } else {
            whatManager.addGroup(WhatGroup(name: name, emotion: emotion, times: []))
            presentationMode.wrappedValue.dismiss()
          }
        }, label: {
          Text("CONFIRM")
        })
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2)
        )
        
        Spacer()
      }
    }
    .padding()
    .alert(isPresented: $alertIsPresented, content: {
      Alert(title: Text("Group name can't be empty!"))
    })
  }
}

struct AddGroupView_Previews: PreviewProvider {
  static var previews: some View {
    AddGroupView()
  }
}

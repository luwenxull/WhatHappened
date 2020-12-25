//
//  AddGroupView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/1.
//

import SwiftUI

struct TextFieldView: View {
  let label: String
  let value: Binding<String>
  let error: String?

  var body: some View {
    VStack(spacing: 4) {
      HStack {
        Text(label)
        TextField("", text: value)
          .padding(8)
          .overlay(
            RoundedRectangle(cornerRadius: 4)
              .stroke(error == nil ? Color.gray : Color.red, lineWidth: 2)
          )
      }
      if error != nil {
        HStack {
          Spacer()
          Text(error!)
            .font(.system(size: 12))
            .foregroundColor(.red)
        }
      }
    }
  }
}

struct ModifyEventView: View {
  var event: WHEvent?
  @ObservedObject var name: WHChecker<String> = WHChecker(value: "", validators: [requiredChecker])
  @ObservedObject var targetCount: WHChecker<String> = WHChecker(value: "1", validators: [requiredChecker, IntChecker])
  @ObservedObject var targetUnit: WHChecker<String> = WHChecker(value: "次", validators: [requiredChecker])
  
  @State var asDailyTarget: Bool = false
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var manager: WHManager
  
  func check() -> Bool {
    if asDailyTarget {
      let errors = [name.check(), targetCount.check(), targetUnit.check()]
      return !errors.contains(false)
    } else {
      return name.check()
    }
  }
  
  
  var body: some View {
    VStack {
      HStack {
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("取消")
        })
        
        Spacer()
        
        Button(action: {
          if check() {
            if asDailyTarget {
              manager.addEvent(WHEvent(name: name.value, asDailyTarget: true, targetCount: Int(targetCount.value)!, targetUnit: targetUnit.value, records: [:]))
            } else {
              manager.addEvent(WHEvent(name: name.value))
            }
            presentationMode.wrappedValue.dismiss()
          }
        }, label: {
          Text("确认")
        })
      }
      .padding()
      
      Divider()

      VStack(spacing: 16) {
        TextFieldView(label: "事件名称：", value: name.binding, error: name.error)
        Toggle(isOn: $asDailyTarget, label: { Text("作为每日目标：") })
        if asDailyTarget {
          TextFieldView(label: "目标计数：", value: targetCount.binding, error: targetCount.error)
          TextFieldView(label: "计数单位：", value: targetUnit.binding, error: targetUnit.error)
        }
      }
      .padding()
      
      Spacer()
    }
    .onAppear(perform: {
//      if event != nil {
//        name = event!.name
//      }
    })
  }
}

struct AddGroupView_Previews: PreviewProvider {
  static var previews: some View {
    ModifyEventView()
  }
}

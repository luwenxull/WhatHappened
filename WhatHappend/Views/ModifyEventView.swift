//
//  AddGroupView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/1.
//

import SwiftUI

struct VerticalFormItem<Content: View>: View {
  let label: String
  let content: () -> Content
  var body: some View {
    VStack(spacing: 4) {
      VStack(alignment: .leading) {
        Text(label)
          .foregroundColor(.gray)
        content()
      }
    }
  }
}

struct TextFieldView: View {
  let label: String
  let value: Binding<String>
  let error: String?
  
  var body: some View {
    VStack(spacing: 4) {
      HStack() {
        Text(label)
          .foregroundColor(.gray)
        TextField("", text: value)
          .padding(10)
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(error == nil ? Color.gray : Color.red, lineWidth: 1)
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
  @State var name: String = ""
  @State var asDailyTarget: Bool = true
  @State var targetUnit: String = "次"
  @State var targetCount: Int = 1
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var manager: WHManager
  @State var errors: [String: String] = [:]
  
  func check() -> Bool {
    var checkers = [WHChecker(key: "name", binding: $name, validators: [requiredChecker])]
    if asDailyTarget {
      checkers.append(WHChecker(key: "targetUnit", binding: $targetUnit, validators: [requiredChecker]))
    }
    
    var errors: [String: String] = [:]
    let hasError = !checkers.map {
      $0.check(collector: &errors)
    }.contains(false)
    self.errors = errors
    
    return hasError
  }
  
  var body: some View {
    VStack {
      VStack(spacing: 16) {
        TextFieldView(label: "事件名称：", value: $name, error: errors["name"])
        Divider()
        Toggle(isOn: $asDailyTarget, label: { Text("每日目标：") })
          .foregroundColor(.gray)
        
        if asDailyTarget {
          Divider()
          
          VStack(spacing: 16) {
            Stepper(value: $targetCount, in: 1...10) {
              Text("目标计数：")
                .foregroundColor(.gray)
            }
            
            TextFieldView(label: "计数单位：", value: $targetUnit, error: errors["targetUnit"])
            
            HStack {
              Spacer()
              Text("计数：\(targetCount)\(targetUnit)")
                .underline()
                .foregroundColor(.gray)
            }
          }
        }
      }
      .padding()
      
      Spacer()
    }
    .onAppear(perform: {
      if let e = event {
        name = e.name
        asDailyTarget = e.asDailyTarget
        if e.asDailyTarget {
          targetUnit = e.targetUnit!
          targetCount = e.targetCount!
        }
      }
    })
    .navigationBarTitle(event == nil ? "添加事件" : "修改事件")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing, content: {
        Button(action: {
          if check() {
            presentationMode.wrappedValue.dismiss()
            if let e = event {
              // 更新
              e.update(name: name, asDailyTarget: asDailyTarget, targetCount: targetCount, targetUnit: targetUnit)
            } else {
              if asDailyTarget {
                manager.addEvent(WHEvent(name: name, asDailyTarget: true, targetCount: targetCount, targetUnit: targetUnit, records: [:]))
              } else {
                manager.addEvent(WHEvent(name: name))
              }
            }
          }
        }, label: {
          Text("确认")
        })
      })
    }
  }
}

struct AddGroupView_Previews: PreviewProvider {
  static var previews: some View {
    ModifyEventView()
  }
}

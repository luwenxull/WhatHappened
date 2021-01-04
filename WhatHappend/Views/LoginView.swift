//
//  LoginView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/16.
//

import SwiftUI
import Dispatch

enum LoginStatus {
  case login, register
}

struct LoginView: View {
  @State var username: String = ""
  @State var password: String = ""
  @State var status: LoginStatus = .login
  @State var hint: String = ""
  @State var showHint: Bool = false
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var manager: WHManager
  
  var body: some View {
    VStack {
      VStack(spacing: 16) {
        TextField("用户名", text: $username)
          .padding()
          .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2.0)
          )
        
        SecureField("密码", text: $password)
          .padding()
          .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2.0)
          )
      }
      .padding()
      if status == .login {
        VStack {
          RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.accentColor)
            .frame(height: 50)
            .overlay(
              Button(action: {
                login()
              }, label: {
                Text("登录")
              })
              .foregroundColor(.white)
            )
          Button(action: {
            status = .register
          }, label: {
            Text("还没有账户，创建一个")
              .foregroundColor(.gray)
              .font(.system(size: 12))
          })
        }
        .padding()
      }
      
      if status == .register {
        VStack {
          RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.accentColor)
            .frame(height: 50)
            .overlay(
              Button(action: {
                register()
              }, label: {
                Text("注册")
              })
              .foregroundColor(.white)
            )
          Button(action: {
            status = .login
          }, label: {
            Text("已有账户，登录")
              .foregroundColor(.gray)
              .font(.system(size: 12))
          })
        }
        .padding()
      }
    }
    .padding()
    .alert(isPresented: $showHint, content: {
      Alert(title: Text(LocalizedStringKey(hint)))
    })
    .navigationBarTitle("登录")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  func login() {
    makeRequest(
      url: "\(WHRequestConfig.baseURL)/login",
      config: jsonConfig(data: try? JSONSerialization.data(withJSONObject: ["username": username, "password": password]), method: "POST"),
      success: { _ in
        UserDefaults.standard.setValue(username, forKey: "username")
        WHManager.current.restore(success: {}, fail: {})
        DispatchQueue.main.async {
          presentationMode.wrappedValue.dismiss()
        }
      },
      fail: { rf in
        if rf.response != nil {
          hint = rf.response!.message
          showHint = true
        }
      })
  }
  
  func register() {
    makeRequest(
      url: "\(WHRequestConfig.baseURL)/user",
      config: jsonConfig(data: try? JSONSerialization.data(withJSONObject: ["username": username, "password": password]), method: "POST"),
      success: { (data) in
        UserDefaults.standard.setValue(username, forKey: "username")
        DispatchQueue.main.async {
          presentationMode.wrappedValue.dismiss()
        }
      },
      fail: { rf in
        if rf.response != nil {
          hint = rf.response!.message
          showHint = true
        }
      })
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}

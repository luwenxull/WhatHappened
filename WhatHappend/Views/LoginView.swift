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
        TextField("Username", text: $username)
          .padding()
          .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 2.0)
          )
        
        SecureField("Password", text: $password)
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
                Text("Sign in")
              })
              .foregroundColor(.white)
            )
          Button(action: {
            status = .register
          }, label: {
            Text("No account, create one")
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
                Text("Sign up")
              })
              .foregroundColor(.white)
            )
          Button(action: {
            status = .login
          }, label: {
            Text("Already have an account")
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
    .navigationBarTitle("Sign in")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  func login() {
    makeRequest(
      url: "\(WHRequestConfig.baseURL)/login",
      config: jsonConfig(data: try? JSONSerialization.data(withJSONObject: ["username": username, "password": password]), method: "POST"),
      success: { _ in
        UserDefaults.standard.setValue(username, forKey: "username")
        DispatchQueue.main.async {
          manager.refresh()
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

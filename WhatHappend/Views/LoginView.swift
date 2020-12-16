//
//  LoginView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/16.
//

import SwiftUI

enum LoginStatus {
  case login, register
}

struct LoginView: View {
  @State var username: String = ""
  @State var password: String = ""
  @State var status: LoginStatus = .login
  var body: some View {
    VStack {
      VStack {
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
              Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Login")
              })
              .foregroundColor(.white)
            )
          Button(action: {
            status = .register
          }, label: {
            Text("No account. Register")
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
                Text("Register")
              })
              .foregroundColor(.white)
            )
          Button(action: {
            status = .login
          }, label: {
            Text("Have account. Login")
              .foregroundColor(.gray)
              .font(.system(size: 12))
          })
        }
        .padding()
      }


    }
    .padding()
    .navigationBarTitle("Login")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  func register() {
    makeRequest(url: "https://wxxfj.xyz:3000/user", config: postConfig(json: ["username": username, "password": password])) { (res) in
      print("hello")
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}

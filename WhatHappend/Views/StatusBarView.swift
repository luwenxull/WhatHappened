//
//  StatusBarView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/25.
//

import SwiftUI

struct StatusBarView: View {
  var ratio: CGFloat
  var body: some View {
    GeometryReader { reader in
      ZStack {
        RoundedRectangle(cornerRadius: 8)
          .fill(
            Color.gray.opacity(0.2)
          )
          .frame(width: reader.size.width)
        HStack {
          RoundedRectangle(cornerRadius: 8)
            .fill(
              LinearGradient(
                gradient: Gradient(colors: [Color.accentColor.opacity(0.2), Color.accentColor.opacity(1)]),
                startPoint: .leading,
                endPoint: .trailing
              )
            )
            .animation(.easeIn)
            .frame(width: reader.size.width * (min(1, ratio)))
          Spacer()
        }
      }
    }
    .frame(height: 16)
  }
}

struct StatusBarView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      StatusBarView(ratio: 0.3)
      StatusBarView(ratio: 0.5)
      StatusBarView(ratio: 1)
    }
  }
}

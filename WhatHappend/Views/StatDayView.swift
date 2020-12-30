//
//  StatDayView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/30.
//

import SwiftUI

enum StatDayType {
  case dot, circle
}

struct StatDayView: View {
  var type: StatDayType
  var label: String
  var ratio: Double?
  var dotted: Bool?
  
  func circle(proxy: GeometryProxy) -> some View {
    let path =
      Path({ path in
        path.addArc(
          center: .init(x: proxy.size.width / 2, y: proxy.size.height / 2),
          radius: min(proxy.size.width / 2, proxy.size.height / 2),
          startAngle: .init(degrees: 0),
          endAngle: .init(degrees: ratio! * Double(360)),
          clockwise: false
        )
      })
      .rotation(.init(degrees: -90))
    return path.stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .round))
  }
  
  func dot() -> some View {
    Circle()
      .fill(Color.accentColor.opacity(dotted == true ? 1 : 0))
      .frame(width: 10, height: 10)
      
  }
  
  var body: some View {
    ZStack {
      GeometryReader { proxy in
        if type == .dot {
          dot()
        } else {
          circle(proxy: proxy)
        }
      }
      Text(label)
        .italic()
    }
//    .background(Color.red)
  }
}

struct StatDayView_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      StatDayView(type: .dot, label: "1")
      StatDayView(type: .dot, label: "1", dotted: true)
      StatDayView(type: .circle, label: "1", ratio: 0.75)
    }
    .frame(height: 100)
  }
}

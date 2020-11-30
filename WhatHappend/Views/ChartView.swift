//
//  ChartView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/30.
//

import SwiftUI

struct ChartView: View {
  let bars: [Bar]
  var _maxValue: Int?
  
  var maxValue: Int {
    if _maxValue != nil {
      return _maxValue!
    }
    var _max = 0
    for bar in bars {
      _max = max(_max, bar.value)
    }
    return _max
  }
  @State var display: Bool = false
  
  
  var body: some View {
    GeometryReader { proxy in
      VStack {
          HStack(alignment: .bottom, spacing: 0) {
            ForEach(bars.indices, id: \.self, content: { index in
              Capsule()
                .foregroundColor(.accentColor)
                .padding(.horizontal, 4)

                .onTapGesture(perform: {
                  
                })
                .frame(width: (proxy.size.width - 16) / CGFloat(bars.count), height: CGFloat(200 * bars[index].value / maxValue))
            })
          }
        
        HStack {
          Text(bars[0].label)
          Spacer()
          Text(bars[bars.count - 1].label)
        }
      }
      .padding(.all, 8)
    }
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView(bars: [
      Bar(value: 1, label: "周一"),
      Bar(value: 2, label: "2"),
      Bar(value: 13, label: "3"),
      Bar(value: 14, label: "4"),
      Bar(value: 21, label: "5"),
      Bar(value: 11, label: "6"),
      Bar(value: 9, label: "周日"),
    ])
  }
}

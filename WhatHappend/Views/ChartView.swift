//
//  ChartView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/30.
//

import SwiftUI

struct ChartView: View {
  var bars: [Bar]
  let height: Float
  
  var maxValue: Int {
    var _max: Int = 0
    for bar in bars {
      _max = max(_max, bar.value)
    }
    return _max
  }
  
  @State var tapped: Int = 0
  
  var body: some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          HStack(alignment: .firstTextBaseline) {
            Text("\(bars[tapped].value)")
              .font(.system(size: 30))
            Text("times")
              .font(.system(size: 14))
              .foregroundColor(.gray)
          }
          Text("\(bars[tapped].label)")
            .font(.system(size: 14))
            .foregroundColor(.gray)
        }
        .padding(8)
        .overlay(
          RoundedRectangle(cornerRadius: 8.0)
            .fill(Color.gray.opacity(0.2))
        )
        Spacer()
      }
      
      HStack(alignment: .bottom, spacing: 0) {
        ForEach(bars.indices, id: \.self, content: { index in
          ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            RoundedRectangle(cornerRadius: 8)
              .foregroundColor(.gray)
              .opacity(index == tapped ? 0.6 : 0.2)
              .padding(.horizontal, 2)
              .onTapGesture(perform: {
                tapped = index
              })
              .frame(height: CGFloat(height))
            
            RoundedRectangle(cornerRadius: 8)
              .foregroundColor(.accentColor)
              .padding(.horizontal, 2)
              .onTapGesture(perform: {
                tapped = index
              })
              .frame(height: CGFloat(height * Float(bars[index].value) / Float(maxValue)))
            
          }
        })
      }
      
      HStack {
        Text(bars[0].label)
        Spacer()
        Text(bars[bars.count - 1].label)
      }
      .font(.system(size: 12))
      .foregroundColor(.gray)
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
    ], height: 200)
  }
}

//
//  ChartView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/25.
//

import SwiftUI

struct BarsView: View {
  var bars: [Int]
  let height: CGFloat
  
  var maxValue: Int {
    var _max: Int = 0
    for bar in bars {
      _max = max(_max, bar)
    }
    return _max
  }

  
  var body: some View {
    VStack {
      HStack(alignment: .bottom, spacing: 0) {
        ForEach(bars.indices, id: \.self, content: { index in
          ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            RoundedRectangle(cornerRadius: 8)
              .foregroundColor(.gray)
              .opacity(0.2)
              .padding(.horizontal, 2)
              .frame(height: height)
            
            RoundedRectangle(cornerRadius: 8)
              .foregroundColor(.accentColor)
              .padding(.horizontal, 2)
              .frame(height: maxValue > 0 ? height * CGFloat(bars[index]) / CGFloat(maxValue) : 0)
            
          }
        })
      }
    }
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      BarsView(bars: [
        1,2,4,22,14,9,6
      ], height: 100)
      BarsView(bars: [
        0,0,0,0,0,0,0
      ], height: 100)
    }
  }
}

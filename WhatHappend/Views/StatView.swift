//
//  StatView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/2.
//

import SwiftUI

struct StatView: View {
  var group: WhatGroup
  @State var month: String = ""
  
  var body: some View {
    VStack {
      HStack {
        Text("选择月份")
        Picker(selection: $month, label: Text("选择月份"), content: {
          ForEach(Array(group.datesGroupedByMonth.keys).sorted(), id: \.self, content: { key in
            Text(key).tag(key)
          })
        })
//        .frame(height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .pickerStyle(InlinePickerStyle())
      }
      if (!month.isEmpty) {
//        Divider()
        ChartView(bars: getBars(group.datesGroupedByMonth[month]!))
      }
      Spacer()
    }
//    .padding()
  }
  
  func getBars(_ dates: [Date]) -> [Bar] {
    var values = [Int: Int]()
    for date in dates {
      let day = date.day
      if values[day] == nil {
        values[day] = 0
      }
      values[day]! += 1
    }
    
    let end = Calendar.lastDayOfMonth(dates[0]).day
    return Array(0...end).map({day in
      return Bar(value: values[day] != nil ? values[day]! : 0, label: "\(day)")
    })
  }
}

struct StatView_Previews: PreviewProvider {
  static var previews: some View {
    StatView(group: WhatGroup(name: "", emotion: .happy, times: [
      WhatTime(),
    ]))
  }
}

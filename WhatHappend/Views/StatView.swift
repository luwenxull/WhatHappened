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
  @State var isPresented: Bool = true
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Picker(selection: $month, label: Text("Choose a month"), content: {
          ForEach(Array(group.datesGroupedByMonth.keys).sorted(), id: \.self, content: { key in
            Text(key).tag(key)
          })
        })
        .padding()
        .pickerStyle(MenuPickerStyle())
        Spacer()
      }
      if (!month.isEmpty) {
        ChartView(bars: getBars(), height: 150).id(UUID())
      }
      Spacer()
    }
    
  }
  
  func getBars() -> [Bar] {
    let dates = group.datesGroupedByMonth[month]!
    var values = [Int: Int]()
    for date in dates {
      let day = date.day
      if values[day] == nil {
        values[day] = 0
      }
      values[day]! += 1
    }
    
    let end = Calendar.lastDayOfMonth(dates[0]).day
    return Array(1...end).map({day in
      return Bar(value: values[day] != nil ? values[day]! : 0, label: "\(month)-\(day)")
    })
  }
}

struct StatView_Previews: PreviewProvider {
  static var previews: some View {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return StatView(group: WhatGroup(name: "", emotion: .happy, times: [
      WhatTime(date: formatter.date(from: "2020-12-31")!, description: ".."),
      WhatTime(date: formatter.date(from: "2020-02-02")!, description: "..")
    ]))
  }
}

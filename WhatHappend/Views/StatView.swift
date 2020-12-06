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
  
  var allMonths: [Dictionary<String, Any>.Key] {
    Array(group.datesGroupedByMonth.keys).sorted()
  }
  
  var body: some View {
    VStack() {
      HStack {
        Picker(selection: $month, label: month.isEmpty ? Text("Choose a month") : Text(month), content: {
          ForEach(allMonths, id: \.self, content: { key in
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

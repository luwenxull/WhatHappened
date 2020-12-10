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
  @State var tempMonth: String = ""
  @State var showPopover: Bool = false
  
  var allMonths: [Dictionary<String, Any>.Key] {
    Array(group.datesGroupedByMonth.keys).sorted()
  }
  
  var body: some View {
    VStack() {
      VStack(spacing: 4) {
        getStatLine(hint: "Total records", detail: "\(group.times.count)")
        getStatLine(hint: "First record", detail: formatTime(time: group.times.first!))
        getStatLine(hint: "Last record", detail: formatTime(time: group.times.last!))
      }
      .padding(.vertical)
      
      if (!month.isEmpty) {
        ChartView(bars: getBars(), height: 150).id(UUID())
      }
      
      Spacer()
      
      Button(action: {
        showPopover.toggle()
      }, label: {
        Text("Choose a month to see detail")
      })
      .padding()
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.accentColor, lineWidth: 2)
      )
      .popover(isPresented: $showPopover, content: {
        VStack(spacing: 0) {
          HStack {
            Button(action: {
              showPopover = false
            }, label: {
              Text("Cancel")
            })
            Spacer()
            Button(action: {
              month = tempMonth
              showPopover = false
            }, label: {
              Text("Confirm")
            })
          }
          .padding()
          
          Divider()
          
          Picker("", selection: $tempMonth, content: {
            ForEach(allMonths, id: \.self, content: { key in
              Text(key).tag(key)
            })
          })
          
          Spacer()
        }
      })
    }
    .padding()
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
  
  func formatTime(time: WhatTime) -> String {
    DateFormatter.localizedString(from: time.date, dateStyle: .medium, timeStyle: .medium)
  }
  
  func getStatLine(hint: String, detail: String) -> some View {
    HStack(alignment: .firstTextBaseline) {
      HStack(alignment: .firstTextBaseline, spacing: 0) {
        Text(LocalizedStringKey(hint))
        Text(": ")
      }
      .font(.system(size: 14))
      .foregroundColor(.gray)
      
      Text(detail)
        .font(.system(size: 14))
      Spacer()
    }
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

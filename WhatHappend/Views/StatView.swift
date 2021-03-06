//
//  StatView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/12/2.
//

import SwiftUI

struct StatView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.colorScheme) var colorScheme
  
  @State var date: Date = Date()
  var event: WHEvent
  
  var columns: [GridItem] {
    Array(repeating: .init(.flexible()), count: 7)
  }
  
  var days: [Int] {
    let (start, end) = Calendar.containingMonth(date)
    let startDay = start.day
    let endDay = end.day
    var results: [Int] = []
    
    if start.weekDay > 1 {
      for item in -start.weekDay + 1..<0 {
        results.append(item)
      }
    }
    
    results.append(contentsOf: startDay...endDay)
    return results
  }
  
  var weekDays: [String] {
    return ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
  }
  
  
  var body: some View {
    ScrollView {
      HStack {
        
        Spacer()
        
        Button(action: {
          presentationMode.wrappedValue.dismiss()
        }, label: {
          Text("完成")
        })
      }
      .padding()
      .background(
        colorScheme == .light ? Color(red: 0.97, green: 0.97, blue: 0.97) : Color(red: 0.09, green: 0.09, blue: 0.09)
      )
      .overlay(
        Text("统计")
      )
      
      HStack {
        Button(action: {
          let (start, _) = Calendar.containingMonth(date)
          date = Calendar.current.date(byAdding: .day, value: -1, to: start)!
        }, label: {
          Image(systemName: "chevron.left.circle")
        })
        .font(.title2)
        
        Spacer()
        
        Text(date.yearMonthString)
        
        Spacer()
        
        Button(action: {
          let (_, end) = Calendar.containingMonth(date)
          date = Calendar.current.date(byAdding: .day, value: 1, to: end)!
        }, label: {
          Image(systemName: "chevron.right.circle")
        })
        .font(.title2)
      }
      .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
      
      LazyVGrid(columns: columns) {
        ForEach(weekDays, id: \.self) { day in
          Text(day)
        }
        .font(.system(size: 14))
        .foregroundColor(.gray)
      }
      .padding(.horizontal, 8)
      
      Divider()
      
      LazyVGrid(columns: columns, spacing: 4) {
        ForEach(days, id: \.self) { day -> StatDayView in
          if day > 0 {
            if event.asDailyTarget {
              return StatDayView(type: .circle, label: "\(day)", ratio: Double(event.getDayProgress(month: date.yearMonthString, day: day)), dotted: false)
            } else {
              return StatDayView(
                type: .dot,
                label: "\(day)",
                dotted: event.getDayCount(month: date.yearMonthString, day: day) > 0
              )
            }
          } else {
            return StatDayView(type: .dot, label: "")
          }
        }
        .frame(height: 60)
      }
      .padding(.horizontal, 8)
    }
  }
}

struct StatView_Previews: PreviewProvider {
  static var previews: some View {
    return StatView(event: WHEvent(name: "Test", asDailyTarget: true, targetCount: 5, targetUnit: "次", records: ["2021-1":[1:3]]))
  }
}

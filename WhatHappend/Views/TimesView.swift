//
//  TimesView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/25.
//

import SwiftUI

struct TimesView: View {
  @ObservedObject var tag: WhatTag
  @GestureState var isDetectingLongPress = false
  @State var isPressing: Bool = false
  @State var showSheet: Bool = false
  
  var longPress: some Gesture {
    LongPressGesture(minimumDuration: 1)
      .updating($isDetectingLongPress) {
        currentstate, gestureState, transaction in
        gestureState = currentstate
      }
      .onChanged { value in
        isPressing = value
      }
      .onEnded { finished in
        if finished {
          isPressing = false
          tag.addRecord(WhatTime())
        }
      }
  }
  
  var body: some View {
    VStack {
      List {
        ForEach(tag.times, id: \.self) { time in
          VStack(alignment: .leading) {
            Text(DateFormatter.localizedString(from: time.date, dateStyle: .medium, timeStyle: .short))
            if !time.description.isEmpty {
              Text(time.description)
                .foregroundColor(.gray)
                .font(.system(size: 12))
                .padding(.vertical, 4)
            }
          }
        }
        .onDelete(perform: { indexSet in
          for i in indexSet {
            tag.removeRecord(i)
          }
        })
      }
      Spacer()
      HStack {
        Spacer()
        
        Button(action: {
          tag.addRecord(WhatTime())
        }, label: {
          Text("ADD QUICKLY")
        })
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2)
        )
        
        Spacer()
        
        Button(action: {
          showSheet = true
        }, label: {
          Text("ADD")
        })
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accentColor, lineWidth: 2)
        )
        
        Spacer()
      }
    }
    .navigationBarTitle(tag.name)
    .navigationBarTitleDisplayMode(.inline)
//    .toolbar(content: {
//      ToolbarItem(placement: ToolbarItemPlacement.automatic) {
//        NavigationLink(
//          destination: ChartView(bars: [
//            Bar(value: 1, label: "周一"),
//            Bar(value: 2, label: "2"),
//            Bar(value: 13, label: "3"),
//            Bar(value: 14, label: "4"),
//            Bar(value: 21, label: "5"),
//            Bar(value: 11, label: "6"),
//            Bar(value: 9, label: "周日"),
//          ]),
//          label: {
//            Text("STATISTIC")
//          })
//      }
//    })
    .sheet(isPresented: $showSheet, content: {
      AddTimeView(tag: tag)
    })
  }
}

struct TimesView_Previews: PreviewProvider {
  static var previews: some View {
    TimesView(tag: WhatTag(name: "Test", emotion: .happy, times: [WhatTime()]))
  }
}

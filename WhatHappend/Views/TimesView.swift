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
      Circle()
        .frame(width: 80, height: 80, alignment: .center)
        .opacity(isPressing ? 0.8 : 0.4)
        .foregroundColor(.accentColor)
//        .scaleEffect(isPressing ? 1 : 0.7)
        .animation(.easeIn(duration: 1))
        .shadow(radius: 10)
        .gesture(longPress)
      Text("Long press to add quickly")
        .foregroundColor(.gray)
        .font(.system(size: 12))
    }
    .navigationBarTitle(tag.name)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar(content: {
      ToolbarItem(placement: ToolbarItemPlacement.automatic) {
        Button(action: {
          showSheet = true
        }, label: {
          Image(systemName: "plus.circle")
        })
      }
    })
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

//
//  GroupView.swift
//  WhatHappend
//
//  Created by 陆雯旭 on 2020/11/24.
//

import SwiftUI

struct EventView: View {
  @ObservedObject var event: WHEvent
  @State var sheetIsPresented: Bool = false
  @State var actionSheetIsPresented: Bool = false
  @EnvironmentObject var manager: WHManager
  @Environment(\.colorScheme) var colorScheme
  
  let today: Date = Date()
  
  var ratio: CGFloat? {
    guard event.asDailyTarget else {
      return nil
    }
    return min(1.0, CGFloat(event.getDayProgress(date: today)))
  }
  
  var content: AnyView {
    if event.asDailyTarget {
      return AnyView(VStack(alignment: .leading) {
        
        HStack {
          Text(event.name)
            .font(.title3)
          
          Spacer()
          
          if ratio == 1.0 {
            Image(systemName: "checkmark.circle")
              .font(.system(size: 24))
              .foregroundColor(.green)
          }
          
        }
        
        Spacer()
        
        if event.getDayCount(date: today) == 0 {
          HStack {
            Text("今日无记录")
              .foregroundColor(.gray)
            Spacer()
          }
        } else {
          if ratio == 1.0 {
            HStack(alignment: VerticalAlignment.firstTextBaseline) {
              Text("100%")
                .font(.system(size: 36))
                .italic()
                .underline()
                .foregroundColor(.accentColor)
              Text("今日打卡目标已完成!")
                .foregroundColor(.gray)
              Spacer()
            }
          } else {
            HStack() {
              Text("\(event.getDayCount(date: today))")
                .font(.system(size: 36))
                .italic()
                .underline()
              Text("/\(event.targetCount!)\(event.targetUnit!)")
                .font(.system(size: 18))
                .foregroundColor(.gray)
              Spacer()
            }
            .foregroundColor(.accentColor)
          }
        }
        
        Spacer()
        
        HStack {
          Button(action: {
            event.addRecord()
          }, label: {
            HStack(spacing: 0) {
              Image(systemName: "hand.tap")
              Text("打卡")
            }
          })
          Spacer()
          NavigationLink(
            destination: StatView(event: event),
            label: {
              HStack(spacing: 0) {
                Text("统计")
                Image(systemName: "arrow.right.circle")
              }
            })
        }
      })
    } else {
      return AnyView(VStack(alignment: .leading) {
        Text(event.name)
          .font(.title3)
        
        Spacer()
        
        VStack(spacing: 0) {
          HStack {
            Text("当月速览")
              .font(.system(size: 14))
              .foregroundColor(.gray)
            Spacer()
          }
          BarsView(bars: event.monthDistribution, height: 35)
        }
        
        Spacer()
        
        HStack {
          Button(action: {
            event.addRecord()
          }, label: {
            HStack(spacing: 0) {
              Image(systemName: "hand.tap")
              Text("打卡")
            }
          })
          Spacer()
          NavigationLink(
            destination: StatView(event: event),
            label: {
              HStack(spacing: 0) {
                Text("统计")
                Image(systemName: "arrow.right.circle")
              }
            })
        }
      })
    }
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 16)
      .fill(
        colorScheme == .light ? Color(red: 0.95, green: 0.95, blue: 0.95) : Color(red: 0.09, green: 0.09, blue: 0.09)
      )
      .frame(height: 160)
      .overlay(
        GeometryReader { reader in
          ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            if event.asDailyTarget {
              RoundedRectangle(cornerRadius: 0)
                .fill(ratio == 1.0 ? Color.green.opacity(0.4) : Color.accentColor.opacity(0.5))
                .frame(width: reader.size.width * ratio!)
                .animation(.easeIn)
            }
            content
              .padding()
          }
          .contentShape(RoundedRectangle(cornerRadius: 16))
          .clipShape(RoundedRectangle(cornerRadius: 16))
        }
      )
      .contextMenu(menuItems: {
        Button(action: {
          event.resetToday()
        }, label: {
          HStack {
            Image(systemName: "minus.circle")
            Text("重置今日打卡")
          }
        })
        Button(action: {
          sheetIsPresented = true
        }, label: {
          HStack {
            Image(systemName: "pencil.circle")
            Text("修改")
          }
        })
        Button(action: {
          actionSheetIsPresented = true
        }, label: {
          HStack {
            Image(systemName: "trash.circle")
            Text("删除")
          }
        })
      })
      //      .sheet(isPresented: $sheetIsPresented, content: {
      //        ModifyEventView(event: event)
      //      })
      .actionSheet(isPresented: $actionSheetIsPresented, content: {
        ActionSheet(
          title: Text("删除事件同时会删除事件下的所有记录，是否继续？"),
          buttons: [
            .cancel(Text("取消")),
            .destructive(Text("确认"), action: {
              manager.removeEvent(event)
            })
          ])
      })
  }
}

struct GroupView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      EventView(event: WHEvent(name: "Test", asDailyTarget: true, targetCount: 5, targetUnit: "次", records: [:]))
      EventView(event: WHEvent(name: "Another"))
    }
    .padding()
  }
}

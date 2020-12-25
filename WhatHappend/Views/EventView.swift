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
  
  var ratio: CGFloat? {
    guard event.asDailyTarget else {
      return nil
    }
    return min(1.0, CGFloat(event.todayCount) / CGFloat(event.targetCount!))
  }
  
  var content: AnyView {
    if event.asDailyTarget {
      return AnyView(VStack(alignment: .leading) {
        
        HStack(alignment: .top) {
          Text(event.name)
            .font(.title3)
          Spacer()
          Button(action: {
            event.addRecord()
          }, label: {
            if ratio == 1.0 {
              Image(systemName: "checkmark.circle")
                .font(.system(size: 36))
                .foregroundColor(.green)
            } else {
              Image(systemName: "record.circle")
                .font(.system(size: 36))
            }
          })
        }
        
        Spacer()
        
        if event.todayCount == 0 {
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
              Text("\(event.todayCount)")
                .font(.system(size: 36))
                .italic()
                .underline()
              Text("/\(event.targetCount!)\(event.targetUnit!)")
                .font(.system(size: 24))
                .foregroundColor(.gray)
              Spacer()
            }
            .foregroundColor(.accentColor)
          }
        }
        
        Spacer()
        
        HStack {
          Spacer()
          Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Text("统计")
            Image(systemName: "arrow.right.circle")
          })
        }
      })
    } else {
      return AnyView(VStack {
        HStack(alignment: .top) {
          Text(event.name)
            .font(.title3)
          Spacer()
          Button(action: {
            event.addRecord()
          }, label: {
            Image(systemName: "record.circle")
              .font(.system(size: 36))
          })
        }
        Spacer()
        
        BarsView(bars: event.monthDistribution, height: 40)
        
        HStack {
          Spacer()
          Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            Text("统计")
            Image(systemName: "arrow.right.circle")
          })
        }
      })
    }
  }
  
  var body: some View {
    RoundedRectangle(cornerRadius: 16)
      .fill(
        colorScheme == .light ? Color.white : Color(red: 0.09, green: 0.09, blue: 0.09)
      )
      .shadow(color: Color.gray.opacity(0.6), radius: 4, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
      .frame(height: 160)
      .overlay(
        GeometryReader { reader in
          ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            if event.asDailyTarget {
              RoundedRectangle(cornerRadius: 0)
                .fill(ratio == 1.0 ? Color.green.opacity(0.4) : Color.accentColor.opacity(0.4))
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
      .sheet(isPresented: $sheetIsPresented, content: {
        ModifyEventView(event: event)
      })
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

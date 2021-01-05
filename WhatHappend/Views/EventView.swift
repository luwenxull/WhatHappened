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
  @State var linkIsDisplayed: Bool = false
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
                .font(.system(size: 14))
              Spacer()
            }
          } else {
            HStack(alignment: VerticalAlignment.firstTextBaseline) {
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
          Button(action: {
            sheetIsPresented = true
          }, label: {
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
          Button(action: {
            sheetIsPresented = true
          }, label: {
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
    VStack(spacing: 0) {
      NavigationLink(
        destination: ModifyEventView(event: event),
        isActive: $linkIsDisplayed,
        label: {
          EmptyView()
        })
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(
          colorScheme == .light ? Color.white : Color.black
        )
        .frame(height: 160)
        .shadow(color: colorScheme == .light ? Color.gray.opacity(0.4) : Color(red: 0.3, green: 0.3, blue: 0.3), radius: 4, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
        .overlay(
          GeometryReader { reader in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
              if event.asDailyTarget {
                RoundedRectangle(cornerRadius: 0)
//                  .fill(ratio == 1.0 ? Color.green.opacity(0.4) : Color.accentColor.opacity(0.5))
                  .fill(LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.3), Color.accentColor.opacity(0.5)]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
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
            linkIsDisplayed = true
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
        .actionSheet(isPresented: $actionSheetIsPresented, content: {
          ActionSheet(
            title: Text("删除事件同时会删除事件下的所有记录，是否继续？"),
            buttons: [
              .cancel(Text("取消")),
              .destructive(Text("确认"), action: {
                manager.removeEvent(event, removeFromServer: true)
              })
            ])
        })
        .sheet(isPresented: $sheetIsPresented, content: {
          StatView(event: event)
        })
    }
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

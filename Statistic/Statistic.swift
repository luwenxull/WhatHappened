//
//  Statistic.swift
//  Statistic
//
//  Created by 陆雯旭 on 2020/12/9.
//

import WidgetKit
import SwiftUI
import Intents

struct YearCount: Hashable {
  let group: String
  let count: Int
}

class Provider: IntentTimelineProvider {
  var yearCounts: [YearCount] = []
  
  func placeholder(in context: Context) -> StatEntry {
    StatEntry(date: Date(), configuration: ConfigurationIntent(), yearCounts: [])
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (StatEntry) -> ()) {
    let entry = StatEntry(date: Date(), configuration: configuration, yearCounts: yearCounts)
    completion(entry)
  }
  
   func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    
    let counts: [String: [Int: Int]] = (try? load("counts.json", url: FileManager.sharedContainerURL)) ?? [:]
    let names: [String: String] = (try? load("names.json", url: FileManager.sharedContainerURL)) ?? [:]
    
    let year = Date().year
    var yearCounts: [YearCount] = []
    
    for group in counts.keys {
      if let count = (counts[group]!)[year] {
        yearCounts.append(YearCount(group: names[group]!, count: count))
      }
    }
    
    yearCounts.sort { (v1, v2) -> Bool in
      v1.count > v2.count
    }
    
    var count: Int
    
    switch configuration.count {
    case .four:
      count = 4
      break
    default:
      count = 3
    }
    
    count = min(count, yearCounts.count)
    yearCounts = Array(yearCounts[0..<count])
    
    self.yearCounts = yearCounts
    
    let timeline = Timeline(entries: [StatEntry(date: Date(), configuration: configuration, yearCounts: yearCounts)], policy: .never)
    completion(timeline)
  }
}

struct StatEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let yearCounts: [YearCount]
}

struct StatisticEntryView : View {
  var entry: Provider.Entry
  
  var maxCount: Int {
    return entry.yearCounts.reduce(into: 0) { ( _max, yearCount) in
      _max = max(_max, yearCount.count)
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text("Annual statistic")
          .font(.system(size: 14))
          .foregroundColor(.accentColor)
          .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        Spacer()
      }
      .padding(8)
      
      HStack {
        ForEach(entry.yearCounts, id: \.self, content: { yearCount in
          VStack {
            GeometryReader { proxy in
              ZStack(alignment: .bottom) {
                HStack {
                  Spacer()
                  RoundedRectangle(cornerRadius: 4)
                    .fill(Color.accentColor)
                    .frame(width: 30, height: proxy.size.height * CGFloat(yearCount.count) / CGFloat(maxCount))
                  Spacer()
                }
                VStack{}
                  .frame(height: proxy.size.height)
              }
            }
            Text(yearCount.group)
              .font(.caption)
              .foregroundColor(.gray)
              .lineLimit(1)
          }
        })
      }
      .padding(8)
    }
//    .background(Color.black)
  }
}

@main
struct Statistic: Widget {
  let kind: String = "Statistic"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      StatisticEntryView(entry: entry)
    }
    .configurationDisplayName("Statistic")
    .description("Statistics of this year")
    .supportedFamilies([.systemMedium])
  }
}

struct Statistic_Previews: PreviewProvider {
  static var previews: some View {
    StatisticEntryView(entry: StatEntry(
      date: Date(),
      configuration: ConfigurationIntent(),
      yearCounts: [
        YearCount(group: "测试", count: 3),
        YearCount(group: "aother test", count: 50)
      ]
    ))
    .previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}

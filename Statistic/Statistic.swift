//
//  Statistic.swift
//  Statistic
//
//  Created by 陆雯旭 on 2020/12/9.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent())
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration)
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }
    
    
    let counts: [String: [Int: Int]] = (try? load("counts.json")) ?? [:]
    let names: [String: String] = (try? load("names.json")) ?? [:]
    print(FileManager.documentDirectoryURL)
    print(counts)
    print(names)
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
}

struct StatisticEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    print(WhatManager.current == nil)
    return Text(entry.date, style: .time)
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
    .description("This is an example widget.")
  }
}

struct Statistic_Previews: PreviewProvider {
  static var previews: some View {
    StatisticEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}

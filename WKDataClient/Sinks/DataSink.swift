//
//  DataSink.swift
//  WKDataClient
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import Foundation

public enum SinkPriority: Int {
    case high = 1
    case medium = 10
    case low = 30
    case noop = 0
}

public protocol DataSink {
    var useForReading: Bool { get }
    var priority: SinkPriority { get }

    func write(entries: [DiaryEntry]) throws
    func read() -> [DiaryEntry]
}

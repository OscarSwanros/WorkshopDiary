//
//  NetworkSink.swift
//  WKDataClient
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import Foundation

class NetworkSink: DataSink {
    var priority: SinkPriority {
        return .low
    }

    public var useForReading: Bool {
        return true
    }

    public func write(entries: [DiaryEntry]) throws {
        let jsonEncoder = JSONEncoder()
        let collection = DiaryEntryCollection(entries: entries)

        let jsonData = try jsonEncoder.encode(collection)

        let url = URL(string: "https://httbin.org")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData

//        let session = URLSession(configuration: .default)
//        let task = session.dataTask(with: request) { (data, res, error) in
//        }
//
//        task.resume()
    }
    
    public func read() -> [DiaryEntry] {
        return []
    }
}

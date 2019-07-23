//
//  DataSink.swift
//  WKDataClient
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

/**
 A protocol defines an interface that types implement. It's a way for us to
 say what needs to be done to be fully-compliant without actually implementing the behavior,

 DataSink defines the interface that a type that can act as a sink needs to implement.
 */
public protocol DataSink {
    func write(entries: [DiaryEntry]) throws
    func read() -> [DiaryEntry]
}

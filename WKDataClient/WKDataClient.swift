//
//  WKDataClient.swift
//  WKDataClient
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

let dummyContent = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
"""

public final class WKDataClient {
    public static let shared = WKDataClient()

    private init() {
        _entriesStore = self.sinks.last?.read() ?? []
    }

    private var _entriesStore: [DiaryEntry]
    public var entries: [DiaryEntry] {
        get {
            return _entriesStore
        }

        set {
            _entriesStore = newValue

            sync()
        }
    }

    public var sinks: [DataSink] = [
        FileDataSink()
    ]

    private func sync() {
        sinks.forEach { (dataSink) in
            try? dataSink.write(entries: _entriesStore)
        }
    }
}

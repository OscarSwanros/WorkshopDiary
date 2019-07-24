//
//  WKDataClient.swift
//  WKDataClient
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import Foundation

public protocol WKDataClientDelegate {
    func dataClientShouldAddEntries(_ client: WKDataClient) -> Bool

    func dataClient(_ client: WKDataClient, shouldAdd entries: [DiaryEntry], to sink: DataSink) -> Bool
}

public final class WKDataClient {
    public enum SinkType {
        case local
        case network

        func build() -> DataSink {
            switch self {
            case .local:
                return FileSink()
            case .network:
                return NetworkSink()
            }
        }
    }

    public static let shared = WKDataClient()
    public var delegate: WKDataClientDelegate?

    public var sinkTypes: [SinkType] = [.local] {
        didSet {
            sinks = sinkTypes.map { $0.build() }
        }
    }

    init() {
        _entries = []
        resetStores()
    }

    private func resetStores() {
        let readableSinks = sinks.filter { $0.useForReading }

        _entries = readableSinks.last?.read() ?? []
    }

    private var _entries: [DiaryEntry]

    public var entries: [DiaryEntry] {
        get  {
            return _entries
        }

        set {
            guard delegate?.dataClientShouldAddEntries(self) ?? true else { return }

            _entries = newValue

            syncData()
        }
    }

    public var sinks: [DataSink] = [
        FileSink()
        ] {
        didSet {
            resetStores()
        }
    }

    private var mediumCount = 0
    private var lowCount = 0
    private func syncData() {
        executeSync(to: sinks.filter { $0.priority == .high })

        if mediumCount == SinkPriority.medium.rawValue {
            mediumCount = 0
            executeSync(to: sinks.filter { $0.priority == .medium })
        }

        if lowCount == SinkPriority.low.rawValue {
            lowCount = 0
            executeSync(to: sinks.filter { $0.priority == .low })
        }
    }

    private func executeSync(to sinks: [DataSink]) {
        sinks.forEach { (sink) in
            guard delegate?.dataClient(self, shouldAdd: entries, to: sink) ?? true else {
                return
            }

            try? sink.write(entries: entries)
        }
    }
}

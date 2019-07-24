//
//  FileSink.swift
//  WKDataClient
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

class FileSink: DataSink {
    var priority: SinkPriority {
        return .high
    }
    
    var useForReading: Bool {
        return true
    }

    private let fileManager = FileManager()

    private lazy var fileURL: URL = {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = (documents as NSString).appendingPathComponent("entries.dat")

        return URL(fileURLWithPath: filePath)
    }()

    func write(entries: [DiaryEntry]) throws {
        let jsonEncoder = JSONEncoder()
        let collection = DiaryEntryCollection(entries: entries)

        let jsonData = try jsonEncoder.encode(collection)
        try jsonData.write(to: fileURL)
    }

    func read() -> [DiaryEntry] {
        let decoder = JSONDecoder()

        guard
            fileManager.fileExists(atPath: fileURL.path),
            let data = try? Data(contentsOf: fileURL),
            let entriesCollection = try? decoder.decode(DiaryEntryCollection.self, from: data)
            else {
                print("Error")
                return []
        }

        return entriesCollection.entries
    }
}

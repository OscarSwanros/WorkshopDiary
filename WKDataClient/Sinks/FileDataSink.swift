//
//  FileDataSink.swift
//  WKDataClient
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

class FileDataSink: DataSink {
    private let fileManager = FileManager()

    private lazy var file: URL = {
        guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, false).first as NSString? else {
            fatalError("Couldn't load documents directory.")
        }

        let filePath = documentsDirectory.appendingPathComponent("entries.dat")
        let fileURL = URL(fileURLWithPath: filePath)

        return fileURL
    }()

    func write(entries: [DiaryEntry]) throws {
        let collection = DiaryEntryCollection(entries: entries)

        let jsonEncoder = JSONEncoder()
        let json = try jsonEncoder.encode(collection)

        try json.write(to: file)
    }

    func read() -> [DiaryEntry] {
        let jsonDecoder = JSONDecoder()

        guard
            fileManager.fileExists(atPath: file.path),
            let jsonData = try? Data(contentsOf: file),
            let collection = try? jsonDecoder.decode(DiaryEntryCollection.self, from: jsonData)
            else {
                return []
        }

        return collection.entries
    }
}

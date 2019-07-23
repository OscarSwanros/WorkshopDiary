//
//  FileDataSink.swift
//  WKDataClient
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

struct FileDataSink: DataSink {
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
        let jsons = entries.compactMap { (entry) -> Data? in
            let jsonEncoder = JSONEncoder()
            return try? jsonEncoder.encode(entry)
        }

        print(jsons)
    }

    func read() -> [DiaryEntry] {
        return []
    }
}

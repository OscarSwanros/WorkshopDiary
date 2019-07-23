//
//  DiaryEntry.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import Foundation

public struct DiaryEntry {
    public let title: String
    public let content: String
    public let timestamp: Date

    public init(title: String = "", content: String, timestamp: Date = Date()) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }
}

extension DiaryEntry: Codable {
}

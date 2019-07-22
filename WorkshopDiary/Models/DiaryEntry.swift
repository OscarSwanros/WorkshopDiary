//
//  DiaryEntry.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import Foundation

struct DiaryEntry {
    let title: String
    let content: String
    let timestamp: Date

    init(title: String = "", content: String, timestamp: Date = Date()) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }
}

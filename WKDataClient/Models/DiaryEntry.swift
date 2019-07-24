//
//  DiaryEntry.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/23/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import Foundation

struct DiaryEntryCollection: Codable {
    let entries: [DiaryEntry]
}

public struct Coordinates: Codable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct DiaryEntry: Codable {

    public let title: String
    public let content: String
    public let timestamp: Date
    public let coordinates: Coordinates?

    public init(title: String, content: String = "", timestamp: Date = Date(), coordinates: Coordinates) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.coordinates = coordinates
    }
}

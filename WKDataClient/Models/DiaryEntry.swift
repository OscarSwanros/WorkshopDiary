//
//  DiaryEntry.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import Foundation
import CoreLocation

struct DiaryEntryCollection {
    let entries: [DiaryEntry]
}

extension DiaryEntryCollection: Codable { }

public struct Coordinate {
    public let latitude: Double
    public let longitude: Double
}

extension Coordinate: Codable {}

public struct DiaryEntry {
    public let title: String
    public let content: String
    public let timestamp: Date
    public let coordinate: Coordinate

    public init(title: String = "", content: String, timestamp: Date = Date(), coordinate: CLLocationCoordinate2D) {
        self.init(title: title, content: content, timestamp: timestamp, coordinate: Coordinate(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }

    public init(title: String = "", content: String, timestamp: Date = Date(), coordinate: Coordinate) {
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.coordinate = coordinate
    }
}

extension DiaryEntry: Codable {
}

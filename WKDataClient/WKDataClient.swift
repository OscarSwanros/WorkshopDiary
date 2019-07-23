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

    public var entries: [DiaryEntry] = [
        DiaryEntry(title: "Had an excellent day!", content: dummyContent),
        DiaryEntry(title: "Got some ice cream", content: dummyContent),
        DiaryEntry(title: "Went to the beach and I'm feeling great!", content: dummyContent),
        DiaryEntry(title: "Had a chat with my boss about my raise", content: dummyContent),
        DiaryEntry(title: "Got engaged!", content: dummyContent)
    ]
}

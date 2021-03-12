//
//  Episode.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import Foundation

struct Episode: Hashable, Codable, Identifiable {
    var id: String
    var podcastID: Int
    var title: String
    var pubDate: Date?
    var duration: Double
    var remoteURL: String
    var localFilePath: String?
    
    init(id: String, podcastID: Int, title: String, pubDate: Date?, duration: Double, remoteURL: String) {
        self.id = id
        self.podcastID = podcastID
        self.title = title
        self.pubDate = pubDate
        self.duration = duration
        self.remoteURL = remoteURL
        self.localFilePath = nil
    }
    
    init(id: String, title: String, pubDate: Date) {
        self.id = id
        podcastID = 0
        self.title = title
        self.pubDate = pubDate
        duration = 0
        remoteURL = ""
        localFilePath = nil
    }
}

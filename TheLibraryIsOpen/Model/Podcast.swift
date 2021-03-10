//
//  Podcast.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import Foundation

struct Podcast: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var author: String
    var episodes: [Episode]?
    var feedURL: String
    var artworkURL: String
    
    init(id: Int, title: String, author: String, episodes: [Episode]?, feedURL: String, artworkURL: String) {
        self.id = id
        self.title = title
        self.author = author
        self.episodes = episodes
        self.feedURL = feedURL
        self.artworkURL = artworkURL
    }
    
    init(id: Int) {
        self.id = id
        title = ""
        author = ""
        episodes = [Episode]()
        feedURL = ""
        artworkURL = ""
    }
}

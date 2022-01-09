import Foundation

struct Podcast: Hashable, Codable, Identifiable {

    var id: Int
    var title: String
    var author: String
    var episodes: [Episode]?
    var feedUrl: String
    var artworkUrl: String
    
    init(id: Int, title: String, author: String, episodes: [Episode]?, feedUrl: String, artworkUrl: String) {
        self.id = id
        self.title = title
        self.author = author
        self.episodes = episodes
        self.feedUrl = feedUrl
        self.artworkUrl = artworkUrl
    }
    
    init(id: Int) {
        self.id = id
        title = ""
        author = ""
        episodes = [Episode]()
        feedUrl = ""
        artworkUrl = ""
    }

}

import Foundation

struct Podcast: Hashable, Codable, Identifiable {

    var id: Int
    var title: String
    var author: String
    var episodes: [Episode]?
    var feedUrl: String
    var artworkUrl: String
    var lastCheckDate: Date?
    var totalSize: Int?
    
    init(id: Int,
         title: String = "",
         author: String = "",
         episodes: [Episode]? = nil,
         feedUrl: String = "",
         artworkUrl: String = "",
         lastCheckDate: Date? = nil,
         totalSize: Int? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.episodes = episodes
        self.feedUrl = feedUrl
        self.artworkUrl = artworkUrl
        self.lastCheckDate = lastCheckDate
        self.totalSize = totalSize
    }

}

import Foundation

struct Podcast: Hashable, Codable, Identifiable {

    var id: Int
    var title: String
    var author: String
    var episodes: [Episode]?
    var feedUrl: String
    var artworkUrl: String
    
    init(id: Int, titulo: String, autor: String, episodios: [Episode]?, urlFeed: String, urlCapa: String) {
        self.id = id
        self.title = titulo
        self.author = autor
        self.episodes = episodios
        self.feedUrl = urlFeed
        self.artworkUrl = urlCapa
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

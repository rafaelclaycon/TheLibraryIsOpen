import Foundation

struct EpisodeGroup: Identifiable {

    var id: String
    var title: String
    var value: String
    var isSelected: Bool
    var episodes: [Episode]
    
    init(title: String, value: String) {
        id = UUID().uuidString
        self.title = title
        self.value = value
        isSelected = false
        episodes = [Episode]()
    }
    
    init(title: String, value: String, episodes: [Episode]) {
        id = UUID().uuidString
        self.title = title
        self.value = value
        isSelected = false
        self.episodes = episodes
    }

}
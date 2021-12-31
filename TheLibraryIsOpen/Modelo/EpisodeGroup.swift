import Foundation

struct EpisodeGroup: Identifiable {

    var id: String
    var title: String
    var value: String
    var isSelected: Bool
    var episodes: [Episodio]
    
    init(title: String, value: String) {
        id = UUID().uuidString
        self.title = title
        self.value = value
        isSelected = false
        episodes = [Episodio]()
    }
    
    init(title: String, value: String, episodes: [Episodio]) {
        id = UUID().uuidString
        self.title = title
        self.value = value
        isSelected = false
        self.episodes = episodes
    }

}

import Foundation

struct EpisodeGroup: Identifiable {

    var id: String
    var year: String
    var episodes: [Episode]
    var relativeWeight: EpisodeGroupRelativeWeight
    var size: Int {
        return episodes.reduce(into: 0) { $0 + $1.filesize }
    }
    
    init(id: String = UUID().uuidString,
         year: String,
         episodes: [Episode] = [Episode](),
         relativeWeight: EpisodeGroupRelativeWeight = .regular
    ) {
        self.id = id
        self.year = year
        self.episodes = episodes
        self.relativeWeight = relativeWeight
    }

}

enum EpisodeGroupRelativeWeight {

    case lightest, regular, heaviest

}

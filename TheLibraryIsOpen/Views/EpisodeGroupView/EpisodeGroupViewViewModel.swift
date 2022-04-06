import Combine
import Foundation

class EpisodeGroupViewViewModel: ObservableObject {
    
    var groupID: String

    @Published var title: String
    @Published var subtitle: String
    @Published var showWeightEmoji: Bool
    @Published var weightEmoji: String = .empty

    init(group: EpisodeGroup, useWeightEmojis: Bool) {
        groupID = group.id
        title = group.year
        
        let groupSize = Utils.getSizeOf(episodes: group.episodes, withSpaceAndParenteses: false)
        if group.episodes.count == 1 {
            subtitle = LocalizableStrings.PodcastPreview.EpisodeGroupList.episode
        } else {
            subtitle = String(format: LocalizableStrings.PodcastPreview.EpisodeGroupList.episodes, group.episodes.count, groupSize)
        }
        
        if useWeightEmojis {
            showWeightEmoji = group.relativeWeight != .regular
            switch group.relativeWeight {
            case .lightest:
                weightEmoji = "🪶"
            case .heaviest:
                weightEmoji = "🐷"
            default:
                weightEmoji = .empty
            }
        } else {
            showWeightEmoji = false
        }
    }

}

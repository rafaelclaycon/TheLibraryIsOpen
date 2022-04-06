import Combine
import Foundation

class EpisodeGroupViewViewModel: ObservableObject {
    
    var groupID: String

    @Published var title: String
    @Published var subtitle: String
    @Published var showWeightEmoji: Bool
    @Published var weightEmoji: String

    init(group: EpisodeGroup) {
        groupID = group.id
        title = group.year
        
        let groupSize = Utils.getSizeOf(episodes: group.episodes, withSpaceAndParenteses: false)
        if group.episodes.count == 1 {
            subtitle = LocalizableStrings.PodcastPreview.EpisodeGroupList.episode
        } else {
            subtitle = String(format: LocalizableStrings.PodcastPreview.EpisodeGroupList.episodes, group.episodes.count, groupSize)
        }
        
        showWeightEmoji = group.relativeWeight != .regular
        switch group.relativeWeight {
        case .lightest:
            weightEmoji = "🪶"
        default:
            weightEmoji = "🐷"
        }
    }

}

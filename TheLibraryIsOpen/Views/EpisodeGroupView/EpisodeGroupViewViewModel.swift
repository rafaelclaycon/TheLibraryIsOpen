import Combine
import Foundation

class EpisodeGroupViewViewModel: ObservableObject {
    
    var groupID: String

    @Published var title: String
    @Published var subtitle: String

    init(group: EpisodeGroup) {
        groupID = group.id
        title = group.year
        
        let groupSize = Utils.getSizeOf(episodes: group.episodes, withSpaceAndParenteses: false)
        if group.episodes.count == 1 {
            subtitle = LocalizableStrings.PodcastPreview.EpisodeGroupList.episode
        } else {
            var sizeString: String
            if groupSize.isEmpty {
                sizeString = .empty
            } else {
                sizeString = " ~ \(groupSize)"
            }
            subtitle = String(format: LocalizableStrings.PodcastPreview.EpisodeGroupList.episodes, group.episodes.count, sizeString)
        }
    }

}

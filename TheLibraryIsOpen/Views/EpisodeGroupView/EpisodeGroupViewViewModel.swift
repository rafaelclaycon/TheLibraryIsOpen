import Combine
import Foundation

class EpisodeGroupViewViewModel: ObservableObject {
    
    var groupID: String

    @Published var title: String
    @Published var subtitle: String

    init(group: EpisodeGroup) {
        groupID = group.id
        title = group.title
        subtitle = group.value
    }

}

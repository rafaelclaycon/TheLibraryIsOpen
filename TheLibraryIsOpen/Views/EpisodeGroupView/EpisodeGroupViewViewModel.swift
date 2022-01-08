import Combine
import Foundation

class EpisodeGroupViewViewModel: ObservableObject {

    @Published var title: String
    @Published var subtitle: String
    @Published var isSelected: Bool = false

    init(year: String, episodeCount: String, selected: Bool = false) {
        title = year
        subtitle = episodeCount
        isSelected = selected
    }

}

import Combine
import Foundation

class EpisodeCellViewModel: ObservableObject {

    var podcastID: Int
    var episodeID: String

    @Published var title: String
    @Published var pubDate: String
    @Published var duration: String
    @Published var isSelected: Bool = false

    init(episode: Episodio, selected: Bool = false) {
        podcastID = episode.idPodcast
        episodeID = episode.id

        title = episode.titulo
        pubDate = episode.dataPublicacao?.asFullString().uppercased() ?? "-"
        duration = episode.duracao.toDisplayString() + " - 15,2 MB"
        isSelected = selected
    }

}

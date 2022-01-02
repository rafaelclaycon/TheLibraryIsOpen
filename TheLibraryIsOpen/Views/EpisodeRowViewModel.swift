import Combine
import Foundation

class EpisodeRowViewModel: ObservableObject {

    var podcastID: Int
    var episodeID: String

    @Published var title: String
    @Published var pubDate: String
    @Published var duration: String
    @Published var isAvailableOffline: Bool = false

    init(episode: Episodio) {
        podcastID = episode.idPodcast
        episodeID = episode.id

        title = episode.titulo
        pubDate = episode.dataPublicacao?.asFullString().uppercased() ?? "-"
        duration = episode.duracao.toDisplayString() + " - 15,2 MB"
        isAvailableOffline = episode.caminhoLocal != nil
    }

}

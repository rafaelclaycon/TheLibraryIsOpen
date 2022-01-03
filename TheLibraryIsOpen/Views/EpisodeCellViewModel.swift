import Combine
import Foundation

class EpisodeCellViewModel: ObservableObject {

    var podcastID: Int
    var episodeID: String

    @Published var title: String
    @Published var subtitle: String
    @Published var isSelected: Bool = false

    init(episode: Episodio, selected: Bool = false) {
        podcastID = episode.idPodcast
        episodeID = episode.id

        title = episode.titulo
        subtitle = (episode.dataPublicacao?.asShortString() ?? "")  + " - " + episode.duracao.toDisplayString() + " - " + episode.tamanho.toFormattedFileSize()
        isSelected = selected
    }

}

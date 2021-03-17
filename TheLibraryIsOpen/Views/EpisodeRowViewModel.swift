//
//  EpisodeRowViewModel.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 30/11/20.
//

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
        duration = episode.duracao.toDisplayString()
        isAvailableOffline = episode.caminhoLocal != nil
    }
}

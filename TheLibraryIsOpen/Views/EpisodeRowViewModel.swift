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

    init(episode: Episode) {
        podcastID = episode.podcastID
        episodeID = episode.id

        title = episode.title
        pubDate = episode.pubDate?.asFullString().uppercased() ?? "-"
        duration = episode.duration.toDisplayString()
        isAvailableOffline = episode.localFilePath != nil
    }
}

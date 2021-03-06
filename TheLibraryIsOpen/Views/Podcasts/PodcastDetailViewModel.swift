//
//  PodcastDetailViewModel.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import Combine
import Foundation

class PodcastDetailViewModel: ObservableObject {
    @Published var artworkURL: String
    @Published var displayEpisodeList: Bool = false
    @Published var episodes = [Episode]()
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var displayAlert: Bool = false

    init(podcast: Podcast) {
        artworkURL = podcast.artworkURL
        dataManager.getEpisodes(forPodcastID: podcast.id, feedURL: podcast.feedURL) { episodes, error in
            guard error == nil else {
                fatalError(error.debugDescription)
            }
            guard let episodes = episodes else {
                return print("Episodes is empty.")
            }
            self.episodes = episodes

            DispatchQueue.main.async {
                self.displayEpisodeList = episodes.count > 0
            }
        }
    }
    
    func downloadAll() {
        do {
            try dataManager.downloadAllEpisodes(from: 916378162)
        } catch DataManagerError.podcastIDNotFound {
            displayPodcastIDNotFoundAlert()
        } catch DataManagerError.podcastHasNoEpisodes {
            displayPodcastHadNoEpisodesAlert()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Error messages

    private func displayPodcastIDNotFoundAlert() {
        alertTitle = "Um Podcast Com Esse ID Não Foi Encontrado"
        alertMessage = "The Library is Open não encontrou um podcast com o ID especificado."
        displayAlert = true
    }

    private func displayPodcastHadNoEpisodesAlert() {
        alertTitle = "Podcast Sem Episódios"
        alertMessage = "Não foram encontrados episódios para esse podcast."
        displayAlert = true
    }
}

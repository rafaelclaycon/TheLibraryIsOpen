//
//  PodcastListViewModel.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import Combine

class InstrucoesViewModel: ObservableObject {
    @Published var entrada = ""
    @Published var podcasts: [Podcast]?
    @Published var showOptions = false
    @Published var layout: GridLayout = .list
    @Published var showGrid = false

    init(podcasts: [Podcast]?) {
        guard let podcasts = podcasts else {
            return
        }
        self.podcasts = podcasts
        self.podcasts?.sort {
            $0.title.localizedStandardCompare($1.title) == .orderedAscending
        }
        showGrid = true
    }
    
    func processar() {
        /*do {
            try dataManager.obterPodcast(applePodcastsURL: entrada) {
                
            }
        } catch DataManagerError.podcastIDNotFound {
            //displayPodcastIDNotFoundAlert()
        } catch DataManagerError.podcastHasNoEpisodes {
            //displayPodcastHadNoEpisodesAlert()
        } catch {
            fatalError(error.localizedDescription)
        }*/
    }
}

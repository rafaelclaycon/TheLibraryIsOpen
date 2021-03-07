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
    
    func extrairFeedURL() {
        guard !entrada.isEmpty else {
            return //exibirAlertaValorInvalidoCampoEmBranco()
        }
        guard entrada.contains("https://podcasts.apple.com") else {
            return // Não é um link do Apple Podcasts
        }
        let podcastId = String(entrada.suffix(9))
        let linkConsulta = "https://itunes.apple.com/lookup?id=\(podcastId)&entity=podcast"
        
    }
}

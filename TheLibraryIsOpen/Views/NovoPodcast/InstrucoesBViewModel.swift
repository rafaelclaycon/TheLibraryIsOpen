//
//  InstrucoesLinkViewModel.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 12/03/21.
//

import Combine

class InstrucoesBViewModel: ObservableObject {
    @Published var entrada = ""
    @Published var processando = false
    @Published var titulo = ""
    @Published var primeiroEp = ""
    @Published var ultimoEp = ""
    @Published var qtd = ""
    
    func processar() {
        processando = true
        
        do {
            try dataManager.obterPodcast(applePodcastsURL: entrada) { [weak self] podcast, error in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.processando = false
                
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }
                guard let podcast = podcast else {
                    fatalError()
                }
                
                strongSelf.titulo = podcast.title
                strongSelf.primeiroEp = podcast.episodes![0].title
                strongSelf.ultimoEp = podcast.episodes![podcast.episodes!.count - 1].title
                strongSelf.qtd = Utils.getSubtituloPodcast(episodes: podcast.episodes!)
            }
        } catch {
            processando = false
            // TODO
        }
    }
}

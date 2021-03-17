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
                
                strongSelf.titulo = podcast.titulo
                strongSelf.primeiroEp = podcast.episodios![0].titulo
                strongSelf.ultimoEp = podcast.episodios![podcast.episodios!.count - 1].titulo
                strongSelf.qtd = Utils.getSubtituloPodcast(episodes: podcast.episodios!)
            }
        } catch {
            processando = false
            // TODO
        }
    }
}

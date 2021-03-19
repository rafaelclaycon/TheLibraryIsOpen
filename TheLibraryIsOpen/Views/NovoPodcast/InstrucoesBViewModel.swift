//
//  InstrucoesLinkViewModel.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 12/03/21.
//

import Combine
import Foundation

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
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }
                guard let podcast = podcast else {
                    fatalError()
                }
                
                let primeiroEp = podcast.episodios![0]
                let ultimoEp = podcast.episodios![podcast.episodios!.count - 1]
                
                strongSelf.titulo = podcast.titulo
                strongSelf.primeiroEp = primeiroEp.titulo
                //print("Ep no topo da lista: \(primeiroEp.urlRemoto)")
                strongSelf.ultimoEp = ultimoEp.titulo
                //print("Último ep da lista: \(ultimoEp.urlRemoto)")
                strongSelf.qtd = Utils.getSubtituloPodcast(episodes: podcast.episodios!)
                
                //let episodios = podcast.episodios!
                
                /*var tamanho = 0
                for episodio in episodios {
                    tamanho += episodio.tamanho
                }
                
                print("TAMANHO TOTAL: \(tamanho) bytes")*/
                
                strongSelf.processando = false
                
                /*dataManager.baixarEpisodios(arrayEpisodios: episodios, idPodcast: podcast.id) { _ in
                    strongSelf.processando = false
                }*/
            }
        } catch {
            processando = false
            // TODO
        }
    }
}

//
//  Episode.swift
//  TheLibraryIsOpen
//
//  Created by Rafael Schmitt on 25/11/20.
//

import Foundation

struct Episodio: Hashable, Codable, Identifiable {
    var id: String
    var idPodcast: Int
    var titulo: String
    var dataPublicacao: Date?
    var duracao: Double
    var urlRemoto: String
    var caminhoLocal: String?
    
    init(id: String, idPodcast: Int, titulo: String, dataPublicacao: Date?, duracao: Double, urlRemoto: String) {
        self.id = id
        self.idPodcast = idPodcast
        self.titulo = titulo
        self.dataPublicacao = dataPublicacao
        self.duracao = duracao
        self.urlRemoto = urlRemoto
        self.caminhoLocal = nil
    }
    
    init(id: String, titulo: String, dataPublicacao: Date) {
        self.id = id
        idPodcast = 0
        self.titulo = titulo
        self.dataPublicacao = dataPublicacao
        duracao = 0
        urlRemoto = ""
        caminhoLocal = nil
    }
}

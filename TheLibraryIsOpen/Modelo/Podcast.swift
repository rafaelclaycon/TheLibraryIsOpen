import Foundation

struct Podcast: Hashable, Codable, Identifiable {

    var id: Int
    var titulo: String
    var autor: String
    var episodios: [Episodio]?
    var urlFeed: String
    var urlCapa: String
    
    init(id: Int, titulo: String, autor: String, episodios: [Episodio]?, urlFeed: String, urlCapa: String) {
        self.id = id
        self.titulo = titulo
        self.autor = autor
        self.episodios = episodios
        self.urlFeed = urlFeed
        self.urlCapa = urlCapa
    }
    
    init(id: Int) {
        self.id = id
        titulo = ""
        autor = ""
        episodios = [Episodio]()
        urlFeed = ""
        urlCapa = ""
    }

}

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
    
    func getTamanhoEpisodios() -> String {
        guard let episodios = episodios, episodios.count > 0 else {
            return ""
        }
        var tamanho = 0
        for episodio in episodios {
            tamanho += episodio.tamanho
        }
        guard tamanho > 0 else {
            return ""
        }
        return " (\(ByteCountFormatter.string(fromByteCount: Int64(tamanho), countStyle: .file)))"
    }

}

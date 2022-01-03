import Foundation

struct Episodio: Hashable, Codable, Identifiable {

    var id: String
    var idPodcast: Int
    var titulo: String
    var dataPublicacao: Date?
    var duracao: Double
    var urlRemoto: String
    var caminhoLocal: String?
    var tamanho: Int
    var selectedForDownload: Bool
    
    init(id: String, idPodcast: Int, titulo: String, dataPublicacao: Date?, duracao: Double, urlRemoto: String, tamanho: Int) {
        self.id = id
        self.idPodcast = idPodcast
        self.titulo = titulo
        self.dataPublicacao = dataPublicacao
        self.duracao = duracao
        self.urlRemoto = urlRemoto
        self.caminhoLocal = nil
        self.tamanho = tamanho
        self.selectedForDownload = false
    }
    
    init(id: String, titulo: String, dataPublicacao: Date) {
        self.id = id
        idPodcast = 0
        self.titulo = titulo
        self.dataPublicacao = dataPublicacao
        duracao = 0
        urlRemoto = ""
        caminhoLocal = nil
        tamanho = 0
        selectedForDownload = false
    }
    
    init(urlRemoto: String) {
        id = "0"
        idPodcast = 0
        titulo = ""
        dataPublicacao = Date()
        duracao = 0
        self.urlRemoto = urlRemoto
        caminhoLocal = nil
        tamanho = 0
        selectedForDownload = false
    }
    
    init(tamanho: Int) {
        self.init(id: UUID().uuidString,
                  idPodcast: 0,
                  titulo: "",
                  dataPublicacao: nil,
                  duracao: 0,
                  urlRemoto: "",
                  tamanho: tamanho)
    }

}

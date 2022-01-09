import Foundation

struct Episode: Hashable, Codable, Identifiable {

    var id: String
    var podcastId: Int
    var title: String
    var pubDate: Date?
    var duration: Double
    var remoteUrl: String
    var localFilepath: String?
    var filesize: Int
    
    init(id: String, idPodcast: Int, titulo: String, dataPublicacao: Date?, duracao: Double, urlRemoto: String, tamanho: Int) {
        self.id = id
        self.podcastId = idPodcast
        self.title = titulo
        self.pubDate = dataPublicacao
        self.duration = duracao
        self.remoteUrl = urlRemoto
        self.localFilepath = nil
        self.filesize = tamanho
    }
    
    init(id: String, titulo: String, dataPublicacao: Date) {
        self.id = id
        podcastId = 0
        self.title = titulo
        self.pubDate = dataPublicacao
        duration = 0
        remoteUrl = ""
        localFilepath = nil
        filesize = 0
    }
    
    init(urlRemoto: String) {
        id = "0"
        podcastId = 0
        title = ""
        pubDate = Date()
        duration = 0
        self.remoteUrl = urlRemoto
        localFilepath = nil
        filesize = 0
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

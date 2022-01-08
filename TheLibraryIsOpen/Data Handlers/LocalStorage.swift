import Foundation
import SQLite

class LocalStorage {

    private var db: Connection
    private var podcasts = Table("podcasts")
    private var episodios = Table("episodios")

    // MARK: - Init

    init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .cachesDirectory, .userDomainMask, true
        ).first!

        do {
            db = try Connection("\(path)/tlio_db.sqlite3")
            try createPodcasts()
            try createEpisodes()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func createPodcasts() throws {
        let id = Expression<Int64>("id")
        let titulo = Expression<String>("titulo")
        let autor = Expression<String>("autor")
        let urlFeed = Expression<String>("urlFeed")
        let urlCapa = Expression<String>("urlCapa")

        try db.run(podcasts.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(titulo)
            t.column(autor)
            t.column(urlFeed)
            t.column(urlCapa)
        })
    }

    private func createEpisodes() throws {
        let id = Expression<String>("id")
        let id_podcast = Expression<Int64>("idPodcast")
        let titulo = Expression<String>("titulo")
        let data_publicacao = Expression<Date?>("dataPublicacao")
        let duracao = Expression<Double>("duracao")
        let url_remoto = Expression<String>("urlRemoto")
        let caminho_local = Expression<String?>("caminhoLocal")
        let tamanho = Expression<Int64>("tamanho")

        try db.run(episodios.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(id_podcast)
            t.column(titulo)
            t.column(data_publicacao)
            t.column(duracao)
            t.column(url_remoto)
            t.column(caminho_local)
            t.column(tamanho)
        })
    }

    // MARK: - Podcast

    func getPodcastCount() throws -> Int {
        try db.scalar(podcasts.count)
    }

    func insert(podcast: Podcast) throws {
        let insert = try podcasts.insert(podcast)
        try db.run(insert)
    }

    func getAllPodcasts() throws -> [Podcast] {
        var queriedPodcasts = [Podcast]()

        for podcast in try db.prepare(podcasts) {
            queriedPodcasts.append(try podcast.decode())
        }
        return queriedPodcasts
    }

    func deleteAllPodcasts() throws {
        try db.run(podcasts.delete())
    }

    // MARK: - Episode

    func getEpisodeCount() throws -> Int {
        try db.scalar(episodios.count)
    }

    func insert(episode: Episodio) throws {
        let insert = try episodios.insert(episode)
        try db.run(insert)
    }

    func getAllEpisodes(forID idPodcast: Int) throws -> [Episodio] {
        var queriedEpisodes = [Episodio]()

        let id_podcast = Expression<Int>("idPodcast")
        let query = episodios.filter(id_podcast == idPodcast)

        for episode in try db.prepare(query) {
            queriedEpisodes.append(try episode.decode())
        }
        return queriedEpisodes
    }

    func deleteAllEpisodes() throws {
        try db.run(episodios.delete())
    }

    func updateLocalFilePath(forEpisode idEpisodio: String, with caminho: String) {
        let id = Expression<String>("id")
        let episodio = episodios.filter(id == idEpisodio)
        let caminho_local = Expression<String?>("caminhoLocal")
        do {
            if try db.run(episodio.update(caminho_local <- caminho)) > 0 {
                print("Episódio \(idEpisodio) atualizado com o caminho: \(caminho)")
            } else {
                print("Episódio \(idEpisodio) não encontrado.")
            }
        } catch {
            print("falha ao tentar atualizar: \(error)")
        }
    }

}

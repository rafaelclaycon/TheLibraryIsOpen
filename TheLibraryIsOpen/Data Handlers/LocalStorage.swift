import Foundation
import SQLite

class LocalStorage {

    private var db: Connection
    private var podcasts = Table("podcasts")
    private var episodes = Table("episodes")

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
        let titulo = Expression<String>("title")
        let autor = Expression<String>("author")
        let urlFeed = Expression<String>("feedUrl")
        let urlCapa = Expression<String>("artworkUrl")

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
        let podcast_id = Expression<Int64>("podcastId")
        let title = Expression<String>("title")
        let pub_date = Expression<Date?>("pubDate")
        let duration = Expression<Double>("duration")
        let remote_url = Expression<String>("remoteUrl")
        let local_filepath = Expression<String?>("localFilepath")
        let filesize = Expression<Int64>("filesize")
        let offline_status = Expression<Int>("offlineStatus")

        try db.run(episodes.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(podcast_id)
            t.column(title)
            t.column(pub_date)
            t.column(duration)
            t.column(remote_url)
            t.column(local_filepath)
            t.column(filesize)
            t.column(offline_status)
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
        try db.scalar(episodes.count)
    }

    func insert(episode: Episode) throws {
        let insert = try episodes.insert(episode)
        try db.run(insert)
    }

    func getAllEpisodes(forID podcastId: Int) throws -> [Episode] {
        var queriedEpisodes = [Episode]()

        let podcast_id = Expression<Int>("podcastId")
        let query = episodes.filter(podcast_id == podcastId)

        for episode in try db.prepare(query) {
            queriedEpisodes.append(try episode.decode())
        }
        return queriedEpisodes
    }

    func deleteAllEpisodes() throws {
        try db.run(episodes.delete())
    }

    func updateLocalFilePath(forEpisode idEpisodio: String, with caminho: String) {
        let id = Expression<String>("id")
        let episodio = episodes.filter(id == idEpisodio)
        let caminho_local = Expression<String?>("localFilepath")
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
